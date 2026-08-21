const express = require('express');
const { body } = require('express-validator');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const router = express.Router();

const { register, login, forgotPassword, resetPassword, me, updateProfile, deleteAccount, uploadAvatar } = require('../controllers/authController');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');

// ── Multer setup for avatar uploads ──────────────────────
const avatarsDir = path.join(__dirname, '..', 'uploads', 'avatars');
if (!fs.existsSync(avatarsDir)) fs.mkdirSync(avatarsDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, avatarsDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `user_${req.user.id}_${Date.now()}${ext}`);
  },
});
const upload = multer({
  storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5 MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) cb(null, true);
    else cb(new Error('Only image files are allowed'));
  },
});

// POST /api/auth/register
router.post(
  '/register',
  [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('email').isEmail().normalizeEmail().withMessage('Valid email required'),
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  ],
  validate,
  register
);

// POST /api/auth/login
router.post(
  '/login',
  [
    body('email').isEmail().normalizeEmail().withMessage('Valid email required'),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  validate,
  login
);

// POST /api/auth/forgot-password
router.post(
  '/forgot-password',
  [body('email').isEmail().normalizeEmail().withMessage('Valid email required')],
  validate,
  forgotPassword
);

// POST /api/auth/reset-password
router.post(
  '/reset-password',
  [
    body('token').notEmpty().withMessage('Token is required'),
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  ],
  validate,
  resetPassword
);

// GET /api/auth/me  (protected)
router.get('/me', authenticate, me);

// PUT /api/auth/profile  (protected)
router.put('/profile', authenticate, [
  body('name').optional().trim().notEmpty().withMessage('Name cannot be empty'),
  body('email').optional().isEmail().normalizeEmail().withMessage('Valid email required'),
  body('age').optional({ nullable: true }).isInt({ min: 1, max: 120 }).withMessage('Age must be 1-120'),
  body('new_password').optional().isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
], validate, updateProfile);

// DELETE /api/auth/account  (protected)
router.delete('/account', authenticate, deleteAccount);

// POST /api/auth/avatar  (protected)
router.post('/avatar', authenticate, upload.single('avatar'), uploadAvatar);

module.exports = router;
