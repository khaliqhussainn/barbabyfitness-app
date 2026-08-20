const pool = require('../config/connection');

async function listWorkouts(req, res) {
  try {
    const { category } = req.query;
    let sql = 'SELECT * FROM workouts';
    const params = [];
    if (category) {
      sql += ' WHERE category = ?';
      params.push(category);
    }
    sql += ' ORDER BY created_at DESC';
    const [workouts] = await pool.query(sql, params);
    res.json({ success: true, data: workouts });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function getSavedWorkouts(req, res) {
  try {
    const [rows] = await pool.query(
      `SELECT w.*, sw.saved_at FROM workouts w
       JOIN saved_workouts sw ON w.id = sw.workout_id
       WHERE sw.user_id = ?
       ORDER BY sw.saved_at DESC`,
      [req.user.id]
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function getWorkout(req, res) {
  try {
    const { id } = req.params;
    const [[workout]] = await pool.query('SELECT * FROM workouts WHERE id = ?', [id]);
    if (!workout) return res.status(404).json({ success: false, message: 'Workout not found' });

    const [exercises] = await pool.query(
      'SELECT * FROM workout_exercises WHERE workout_id = ? ORDER BY order_index',
      [id]
    );

    let isSaved = false;
    if (req.user) {
      const [[saved]] = await pool.query(
        'SELECT id FROM saved_workouts WHERE user_id = ? AND workout_id = ?',
        [req.user.id, id]
      );
      isSaved = !!saved;
    }

    res.json({ success: true, data: { ...workout, exercises, isSaved } });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function createWorkout(req, res) {
  try {
    const { title, description, duration_minutes, difficulty, category, image_url, exercises = [] } = req.body;
    const [result] = await pool.query(
      'INSERT INTO workouts (title, description, duration_minutes, difficulty, category, image_url) VALUES (?, ?, ?, ?, ?, ?)',
      [title, description, duration_minutes, difficulty, category || null, image_url || null]
    );
    const workoutId = result.insertId;

    if (exercises.length > 0) {
      const vals = exercises.map((e, i) => [workoutId, e.name, e.sets, e.reps, e.rest_seconds || 60, i]);
      await pool.query(
        'INSERT INTO workout_exercises (workout_id, name, sets, reps, rest_seconds, order_index) VALUES ?',
        [vals]
      );
    }

    res.status(201).json({ success: true, message: 'Workout created', data: { id: workoutId } });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function updateWorkout(req, res) {
  try {
    const { id } = req.params;
    const { title, description, duration_minutes, difficulty, category, image_url, exercises } = req.body;

    await pool.query(
      'UPDATE workouts SET title=?, description=?, duration_minutes=?, difficulty=?, category=?, image_url=?, updated_at=NOW() WHERE id=?',
      [title, description, duration_minutes, difficulty, category || null, image_url || null, id]
    );

    if (exercises) {
      await pool.query('DELETE FROM workout_exercises WHERE workout_id = ?', [id]);
      if (exercises.length > 0) {
        const vals = exercises.map((e, i) => [id, e.name, e.sets, e.reps, e.rest_seconds || 60, i]);
        await pool.query(
          'INSERT INTO workout_exercises (workout_id, name, sets, reps, rest_seconds, order_index) VALUES ?',
          [vals]
        );
      }
    }

    res.json({ success: true, message: 'Workout updated' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function deleteWorkout(req, res) {
  try {
    await pool.query('DELETE FROM workouts WHERE id = ?', [req.params.id]);
    res.json({ success: true, message: 'Workout deleted' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function saveWorkout(req, res) {
  try {
    await pool.query(
      'INSERT IGNORE INTO saved_workouts (user_id, workout_id) VALUES (?, ?)',
      [req.user.id, req.params.id]
    );
    res.json({ success: true, message: 'Workout saved' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function unsaveWorkout(req, res) {
  try {
    await pool.query(
      'DELETE FROM saved_workouts WHERE user_id = ? AND workout_id = ?',
      [req.user.id, req.params.id]
    );
    res.json({ success: true, message: 'Workout unsaved' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function logSession(req, res) {
  try {
    const { workout_id, workout_title, duration_seconds, calories_burned } = req.body;
    await pool.query(
      'INSERT INTO workout_sessions (user_id, workout_id, workout_title, duration_seconds, calories_burned) VALUES (?, ?, ?, ?, ?)',
      [req.user.id, workout_id || null, workout_title || 'Workout', duration_seconds || 0, calories_burned || 0]
    );
    res.status(201).json({ success: true, message: 'Session logged' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

async function getSessionHistory(req, res) {
  try {
    const [sessions] = await pool.query(
      `SELECT ws.*, w.category FROM workout_sessions ws
       LEFT JOIN workouts w ON ws.workout_id = w.id
       WHERE ws.user_id = ?
       ORDER BY ws.completed_at DESC`,
      [req.user.id]
    );
    res.json({ success: true, data: sessions });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
}

module.exports = {
  listWorkouts, getSavedWorkouts, getWorkout,
  createWorkout, updateWorkout, deleteWorkout,
  saveWorkout, unsaveWorkout,
  logSession, getSessionHistory,
};
