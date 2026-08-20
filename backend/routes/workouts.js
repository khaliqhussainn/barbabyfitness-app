const { Router } = require('express');
const { body } = require('express-validator');
const validate = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const optionalAuth = require('../middleware/optionalAuth');
const {
  listWorkouts, getSavedWorkouts, getWorkout,
  createWorkout, updateWorkout, deleteWorkout,
  saveWorkout, unsaveWorkout,
} = require('../controllers/workoutController');

const router = Router();

const workoutValidators = [
  body('title').notEmpty().withMessage('Title is required'),
  body('duration_minutes').isInt({ min: 1 }).withMessage('Duration must be a positive integer'),
  body('difficulty').isIn(['beginner', 'intermediate', 'advanced']).withMessage('Invalid difficulty'),
];

router.get('/',           listWorkouts);
router.get('/saved',      authenticate, getSavedWorkouts);
router.get('/:id',        optionalAuth,  getWorkout);
router.post('/',          authenticate, workoutValidators, validate, createWorkout);
router.put('/:id',        authenticate, workoutValidators, validate, updateWorkout);
router.delete('/:id',     authenticate, deleteWorkout);
router.post('/:id/save',  authenticate, saveWorkout);
router.delete('/:id/save',authenticate, unsaveWorkout);

module.exports = router;
