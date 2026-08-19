const pool = require('../config/connection');

async function migrate(req, res) {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name          VARCHAR(120)  NOT NULL,
        email         VARCHAR(255)  NOT NULL UNIQUE,
        password_hash VARCHAR(255)  NOT NULL,
        created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
        updated_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS password_reset_tokens (
        user_id    INT UNSIGNED NOT NULL,
        token      VARCHAR(128) NOT NULL,
        expires_at DATETIME     NOT NULL,
        PRIMARY KEY (user_id),
        UNIQUE KEY uq_token (token),
        CONSTRAINT fk_prt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    return res.json({ success: true, message: 'Migration complete' });
  } catch (err) {
    console.error('[migrate]', err);
    return res.status(500).json({ success: false, message: err.message });
  }
}

module.exports = { migrate };
