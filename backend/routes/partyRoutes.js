const express = require('express');
const router = express.Router();
const partyController = require('../controllers/partyController');

// not required, done by websockets: 
// router.post('/', partyController.createParty)
router.get('/:id', partyController.getPartyById)
router.get('/', partyController.getAllPartys)
// not required, done by websockets:
// router.put('/banplayer/:id', partyController.banPlayer)

module.exports = router;