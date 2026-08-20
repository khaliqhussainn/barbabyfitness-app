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

    await pool.query(`
      CREATE TABLE IF NOT EXISTS workout_sessions (
        id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        user_id          INT UNSIGNED NOT NULL,
        workout_id       INT UNSIGNED NULL,
        workout_title    VARCHAR(255) NOT NULL DEFAULT 'Workout',
        duration_seconds INT          NOT NULL DEFAULT 0,
        calories_burned  INT          NOT NULL DEFAULT 0,
        completed_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_ws_user    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
        CONSTRAINT fk_ws_workout FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE SET NULL
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);

    // Seed sample workouts if none exist
    const [[{ count }]] = await pool.query('SELECT COUNT(*) as count FROM workouts');
    if (count === 0) {
      const workoutsToSeed = [
        ['Full Body Strength', 'A comprehensive routine for total body conditioning. Build explosive strength and maximum calorie burn.', 30, 'intermediate', 'Strength'],
        ['Metabolic Burn HIIT', 'Torch fat and boost endurance with short intense intervals. Maximum calorie burn in minimum time.', 20, 'intermediate', 'Cardio'],
        ['Upper Body Power', 'Build strength and definition in your upper body. Target chest, shoulders, back and arms.', 25, 'advanced', 'Strength'],
        ['Core & Abs Blast', 'Strengthen your core, improve posture and build defined abs with this targeted routine.', 20, 'beginner', 'Strength'],
        ['Morning Cardio Flow', 'Energise your day with this beginner-friendly cardio session. Great for building endurance.', 30, 'beginner', 'Cardio'],
      ];

      for (const [title, description, duration_minutes, difficulty, category] of workoutsToSeed) {
        const [result] = await pool.query(
          'INSERT INTO workouts (title, description, duration_minutes, difficulty, category) VALUES (?, ?, ?, ?, ?)',
          [title, description, duration_minutes, difficulty, category]
        );
        const wid = result.insertId;

        const exerciseMap = {
          'Full Body Strength': [
            ['High Knees', 3, '20'], ['Burpees', 3, '10'], ['Jump Squats', 3, '15'], ['Plank Hold', 3, '60s'],
          ],
          'Metabolic Burn HIIT': [
            ['Mountain Climbers', 3, '20'], ['Jump Lunges', 3, '12'], ['Box Jumps', 3, '10'], ['Burpees', 3, '10'],
          ],
          'Upper Body Power': [
            ['Push-Ups', 4, '15'], ['Pike Push-Ups', 3, '12'], ['Diamond Push-Ups', 3, '10'], ['Tricep Dips', 3, '15'],
          ],
          'Core & Abs Blast': [
            ['Crunches', 3, '20'], ['Leg Raises', 3, '15'], ['Russian Twists', 3, '20'], ['Plank', 3, '45s'],
          ],
          'Morning Cardio Flow': [
            ['Jumping Jacks', 3, '30'], ['High Knees', 3, '20'], ['Step Touches', 3, '30'], ['March in Place', 3, '60s'],
          ],
        };

        const exercises = exerciseMap[title] || [];
        for (let i = 0; i < exercises.length; i++) {
          const [name, sets, reps] = exercises[i];
          await pool.query(
            'INSERT INTO workout_exercises (workout_id, name, sets, reps, rest_seconds, order_index) VALUES (?, ?, ?, ?, ?, ?)',
            [wid, name, sets, reps, 60, i]
          );
        }
      }
    }

    return res.json({ success: true, message: 'Migration complete' });
  } catch (err) {
    console.error('[migrate]', err);
    return res.status(500).json({ success: false, message: err.message });
  }
}

module.exports = { migrate };
