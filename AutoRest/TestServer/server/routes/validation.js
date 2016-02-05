var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')



var specials = function (coverage) {

  router.get('/constantsInPath/constant/value', function (req, res, next) {
      coverage["ConstantsInPath"]++;
      res.status(200).end();
  });
  
  router.post('/constantsInPath/constant/value', function (req, res, next) {
    if (req.body && req.body.constString === 'constant' && req.body.constInt === 0 
        && req.body.child && req.body.child.constProperty === 'constant' 
        && req.body.constChild.constProperty === 'constant'
        && req.body.constChild.constProperty2 === 'constant2') {
        coverage["ConstantsInBody"]++;
        res.status(200).end(JSON.stringify(req.body));
      } else {
        utils.send400(res, next, "Constant values were not present in the body '" + util.inspect(req.body) + "'");
      }
  });
}

specials.prototype.router = router;

module.exports = specials;