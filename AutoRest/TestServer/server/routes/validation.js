var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')



var specials = function (coverage) {
  coverage['ConstantsInPath'] = 0;
  coverage['ConstantsInBody'] = 0;

  router.get('/constantsInPath/constant/value', function (req, res, next) {
      coverage["ConstantsInPath"]++;
      res.status(200).end();
  });
  
  router.post('/constantsInPath/constant/value', function (req, res, next) {
      coverage["ConstantsInBody"]++;
      if (req.body.constString === 'constant' && req.body.constInt === 0) {
        res.status(200).end(JSON.stringify(req.body));
      } else {
        utils.send400(res, next, "Constant values were not present in the body '" + util.inspect(req.body) + "'");
      }
  });
}

specials.prototype.router = router;

module.exports = specials;