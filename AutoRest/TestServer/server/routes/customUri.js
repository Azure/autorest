var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')

var specials = function (coverage) {
  router.get('/', function (req, res, next) {
      coverage['CustomBaseUri']++;
      res.status(200).end();
  });
}

specials.prototype.router = router;
module.exports = specials;