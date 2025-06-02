const express = require('express');
const router = express.Router();
const { verificarUsuari } = require('../controllers/authControllers');

router.post('/', verificarUsuari);

module.exports = router;
