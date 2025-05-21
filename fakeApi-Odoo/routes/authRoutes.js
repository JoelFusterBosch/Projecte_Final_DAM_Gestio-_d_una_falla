const express = require('express');
const router = express.Router();
const { verificarUsuari } = require('../controllers/authControllers');

router.post('/verificar', verificarUsuari);

module.exports = router;
