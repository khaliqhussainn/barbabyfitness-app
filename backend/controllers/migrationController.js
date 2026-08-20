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

    await pool.query(`
      CREATE TABLE IF NOT EXISTS workouts (
        id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        title            VARCHAR(255) NOT NULL,
        description      TEXT,
        duration_minutes INT          NOT NULL DEFAULT 30,
        difficulty       ENUM('beginner','intermediate','advanced') NOT NULL DEFAULT 'beginner',
        category         VARCHAR(100),
        image_url        VARCHAR(500),
        created_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        updated_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS workout_exercises (
        id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        workout_id   INT UNSIGNED NOT NULL,
        name         VARCHAR(255) NOT NULL,
        sets         INT          NOT NULL DEFAULT 3,
        reps         VARCHAR(50)  NOT NULL DEFAULT '10',
        rest_seconds INT          NOT NULL DEFAULT 60,
        order_index  INT          NOT NULL DEFAULT 0,
        CONSTRAINT fk_we_workout FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    await pool.query(`
      CREATE TABLE IF NOT EXISTS saved_workouts (
        id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        user_id    INT UNSIGNED NOT NULL,
        workout_id INT UNSIGNED NOT NULL,
        saved_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uq_user_workout (user_id, workout_id),
        CONSTRAINT fk_sw_user    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
        CONSTRAINT fk_sw_workout FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    return res.json({ success: true, message: 'Migration complete' });
  } catch (err) {
    console.error('[migrate]', err);
    return res.status(500).json({ success: false, message: err.message });
  }
}

module.exports = { migrate };
