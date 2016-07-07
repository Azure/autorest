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

  router.get('/:subscriptionId/:keyName', function (req, res, next) {
    if (req.params.subscriptionId === 'test12' && req.params.keyName === 'key1' 
      && Object.keys(req.query).length == 1 && req.query.keyVersion === 'v1') {
      coverage['CustomBaseUriMoreOptions']++;
      res.status(200).end();
    } else {
      utils.send400(res, next, 'Either one of the path parameters (subscriptionId=test12, keyName=key1) or query parameter (keyVersion=v1) did not match. ' + 
      	'Received parameters are: subscriptionId ' + subscriptionId + ', keyName ' + keyName + ', keyVersion ' + keyVersion);
    }
  });
}

specials.prototype.router = router;
module.exports = specials;