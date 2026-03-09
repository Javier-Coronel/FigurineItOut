const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

router.post('/signin', userController.signin);
router.post('/signout', userController.signout);
router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.put('/changepassword/:id', userController.updatePassword);
router.delete('/:id', userController.deleteUser);

module.exports = router;