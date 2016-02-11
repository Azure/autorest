var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')

var customUri = function (coverage) {
  coverage['CustomBaseUri'] = 0;
  router.get('/example', function (req, res, next) {
      coverage['CustomBaseUri']++;
      res.status(200).end();
  });
}

customUri.prototype.router = router;
module.exports = customUri;