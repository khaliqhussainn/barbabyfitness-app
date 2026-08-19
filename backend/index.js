require('dotenv').config();

const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const { migrate } = require('./controllers/migrationController');

const app = express();

app.use(cors());
app.use(express.json());

// ── Routes ────────────────────────────────────────────────
app.use('/api/auth', authRoutes);

// Run DB migrations (idempotent)
app.get('/migration', migrate);

app.get('/', (_, res) => res.json({ status: 'BarBaby Fitness API running' }));

// ── Start ─────────────────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
