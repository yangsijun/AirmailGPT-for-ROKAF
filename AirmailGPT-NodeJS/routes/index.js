const router = require('express').Router();
const controller = require('./controller');

router.post('/AirmailGPT-for-ROKAF/message', controller.sendMail);

module.exports = router;