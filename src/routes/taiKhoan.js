const express = require('express');
const router = express.Router();
const taiKhoanController = require('../controllers/taiKhoanController');

router.get('/', taiKhoanController.getAllTaiKhoan);
router.get('/create', taiKhoanController.getCreateTaiKhoan);
router.post('/create', taiKhoanController.createTaiKhoan);
router.get('/edit/:id', taiKhoanController.getEditTaiKhoan);
router.post('/update/:id', taiKhoanController.updateTaiKhoan);
router.post('/delete/:id', taiKhoanController.deleteTaiKhoan);

module.exports = router;
