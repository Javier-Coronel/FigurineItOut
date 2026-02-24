const express = require('express');
const router = express.Router();
const playerController = require('../controllers/playerController');

router.post('/', playerController.createPlayer)
router.get('/:id', playerController.getPlayerById)
router.get('/', playerController.getAllPlayers)
router.put('/banplayer/:id', playerController.banPlayer)

module.exports = router;
