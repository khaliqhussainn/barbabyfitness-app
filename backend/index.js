require('dotenv').config();

const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const workoutRoutes = require('./routes/workouts');
const { migrate } = require('./controllers/migrationController');

const app = express();

app.use(cors());
app.use(express.json());

// Serve uploaded avatars as static files
const path = require('path');
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// ── Routes ────────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/workouts', workoutRoutes);

// Run DB migrations (idempotent)
app.get('/migration', migrate);

app.get('/', (_, res) => res.json({ status: 'BarBaby Fitness API running' }));

// ── Start ─────────────────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
