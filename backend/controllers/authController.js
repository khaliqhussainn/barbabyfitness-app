const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const pool = require('../config/connection');
const mailer = require('../config/mailer');

// ── helpers ──────────────────────────────────────────────

function signToken(userId) {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  });
}

// ── Register ─────────────────────────────────────────────

async function register(req, res) {
  const { name, email, password } = req.body;

  try {
    const [rows] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    if (rows.length > 0) {
      return res.status(409).json({ success: false, message: 'Email already in use' });
    }

    const hash = await bcrypt.hash(password, 12);
    const [result] = await pool.query(
      'INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)',
      [name, email, hash]
    );

    const token = signToken(result.insertId);
    return res.status(201).json({
      success: true,
      message: 'Account created',
      token,
      user: { id: result.insertId, name, email },
    });
  } catch (err) {
    console.error('[register]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Login ─────────────────────────────────────────────────

async function login(req, res) {
  const { email, password } = req.body;

  try {
    const [rows] = await pool.query(
      'SELECT id, name, email, password_hash FROM users WHERE email = ?',
      [email]
    );
    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const token = signToken(user.id);
    return res.json({
      success: true,
      token,
      user: { id: user.id, name: user.name, email: user.email },
    });
  } catch (err) {
    console.error('[login]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Forgot Password ───────────────────────────────────────

async function forgotPassword(req, res) {
  const { email } = req.body;

  try {
    const [rows] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    // Always 200 so we don't leak whether an email exists
    if (rows.length === 0) {
      return res.json({ success: true, message: 'If that email is registered you will receive a reset link' });
    }

    const userId = rows[0].id;
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

    await pool.query(
      `INSERT INTO password_reset_tokens (user_id, token, expires_at)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE token = VALUES(token), expires_at = VALUES(expires_at)`,
      [userId, token, expiresAt]
    );

    const resetUrl = `${process.env.APP_URL || 'barbabyfitness://reset-password'}?token=${token}`;

    await mailer.sendMail({
      from: process.env.EMAIL_FROM || 'noreply@barbabyfitness.com',
      to: email,
      subject: 'Reset your BarBaby Fitness password',
      html: `
        <p>Hi,</p>
        <p>Click the link below to reset your password. It expires in 1 hour.</p>
        <p><a href="${resetUrl}">${resetUrl}</a></p>
        <p>If you didn't request this, ignore this email.</p>
      `,
    });

    return res.json({ success: true, message: 'If that email is registered you will receive a reset link' });
  } catch (err) {
    console.error('[forgotPassword]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Reset Password ────────────────────────────────────────

async function resetPassword(req, res) {
  const { token, password } = req.body;

  try {
    const [rows] = await pool.query(
      `SELECT user_id FROM password_reset_tokens
       WHERE token = ? AND expires_at > NOW()`,
      [token]
    );
    if (rows.length === 0) {
      return res.status(400).json({ success: false, message: 'Token is invalid or has expired' });
    }

    const userId = rows[0].user_id;
    const hash = await bcrypt.hash(password, 12);

    await pool.query('UPDATE users SET password_hash = ? WHERE id = ?', [hash, userId]);
    await pool.query('DELETE FROM password_reset_tokens WHERE user_id = ?', [userId]);

    return res.json({ success: true, message: 'Password updated successfully' });
  } catch (err) {
    console.error('[resetPassword]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Me (token verification) ───────────────────────────────

async function me(req, res) {
  try {
    const [rows] = await pool.query(
      'SELECT id, name, email, age, avatar_url, created_at FROM users WHERE id = ?',
      [req.user.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    return res.json({ success: true, data: rows[0] });
  } catch (err) {
    console.error('[me]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Upload Avatar ─────────────────────────────────────────

async function uploadAvatar(req, res) {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'No file uploaded' });
    }
    const avatarUrl = `/uploads/avatars/${req.file.filename}`;
    await pool.query('UPDATE users SET avatar_url = ?, updated_at = NOW() WHERE id = ?', [avatarUrl, req.user.id]);
    return res.json({ success: true, avatar_url: avatarUrl });
  } catch (err) {
    console.error('[uploadAvatar]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Update Profile ────────────────────────────────────────

async function updateProfile(req, res) {
  try {
    const { name, email, age, current_password, new_password } = req.body;
    const userId = req.user.id;

    if (new_password) {
      const [[user]] = await pool.query('SELECT password_hash FROM users WHERE id = ?', [userId]);
      const valid = await bcrypt.compare(current_password || '', user.password_hash);
      if (!valid) {
        return res.status(400).json({ success: false, message: 'Current password is incorrect' });
      }
    }

    const updates = [];
    const params = [];
    if (name !== undefined)  { updates.push('name = ?');  params.push(name); }
    if (email !== undefined) { updates.push('email = ?'); params.push(email); }
    if (age !== undefined)   { updates.push('age = ?');   params.push(age !== null && age !== '' ? parseInt(age, 10) : null); }
    if (new_password) {
      const hash = await bcrypt.hash(new_password, 12);
      updates.push('password_hash = ?');
      params.push(hash);
    }

    if (updates.length === 0) {
      return res.json({ success: true, message: 'Nothing to update' });
    }

    params.push(userId);
    await pool.query(`UPDATE users SET ${updates.join(', ')}, updated_at = NOW() WHERE id = ?`, params);

    const [[updated]] = await pool.query('SELECT id, name, email, age, avatar_url, created_at FROM users WHERE id = ?', [userId]);
    return res.json({ success: true, message: 'Profile updated', data: updated });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ success: false, message: 'Email already in use' });
    }
    console.error('[updateProfile]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

// ── Delete Account ────────────────────────────────────────

async function deleteAccount(req, res) {
  try {
    await pool.query('DELETE FROM users WHERE id = ?', [req.user.id]);
    return res.json({ success: true, message: 'Account deleted' });
  } catch (err) {
    console.error('[deleteAccount]', err);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
}

module.exports = { register, login, forgotPassword, resetPassword, me, updateProfile, deleteAccount, uploadAvatar };
