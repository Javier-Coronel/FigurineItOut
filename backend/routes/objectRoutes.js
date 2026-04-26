const express = require('express');
const router = express.Router();
const objectController = require('../controllers/objectController');

router.get('/getObjects/:page', objectController.getObjects)
router.get('/getBannedObjects/:page', objectController.getBannedObjects)
router.get('/getPlayerObjects/:page/id/:id', objectController.getPlayerObjects)
router.get('/getPartyObjects/:page/id/:id', objectController.getPartyObjects)
router.get('/getAvalibleObjects/:page', objectController.getAvalibleObjects)
router.get('/:id', objectController.getObject)

module.exports = router;