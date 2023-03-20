var express = require('express');
var app = express();
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

const routes = require('./routes/index');
app.use(routes)

module.exports = app;