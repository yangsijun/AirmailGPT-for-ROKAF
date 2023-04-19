const router = require('express').Router();
const controller = require('./controller');

router.post('/AirmailGPT-for-ROKAF/mails', controller.sendMail);

router.post('/AirmailGPT-for-ROKAF/test', controller.test);
module.exports = router;