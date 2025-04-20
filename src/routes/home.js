const express = require('express');
const router = express.Router();
const homeController = require('../controllers/homeController');

router.get('/', homeController.getHomePage);
router.get('/abc', homeController.getABC);

module.exports = router;
