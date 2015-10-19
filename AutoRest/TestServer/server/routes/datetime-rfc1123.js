var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils');

var datetimeRfc1123 = function(coverage) {

  router.put('/max', function(req, res, next) {
    if (new Date(req.body).toString() === new Date('Fri, 31 Dec 9999 23:59:59 GMT').toString()) {
      coverage['putDateTimeRfc1123Max']++;
      res.status(200).end();
    } else {
      utils.send400(res, next, "Did not like the value provided for max datetime-rfc1123 in the req " + util.inspect(req.body));
    }
  });
  
  router.put('/min', function(req, res, next) {
    if (new Date(req.body).toString() === new Date('Mon, 01 Jan 0001 00:00:00 GMT').toString()) {
      coverage["putDateTimeRfc1123Min"]++;
      res.status(200).end();
    } else {
      utils.send400(res, next, "Did not like the value provided for min datetime-rfc1123 in the req " + util.inspect(req.body));
    }
  });
  
  router.get('/max/:case', function(req, res, next) {
    var ret = '"Fri, 31 Dec 9999 23:59:59 GMT"';
    if (req.params.case === 'lowercase') {
      coverage["getDateTimeRfc1123MaxUtcLowercase"]++;
      ret = ret.toLowerCase();
    } else if (req.params.case === 'uppercase') {
      coverage["getDateTimeRfc1123MaxUtcUppercase"]++;
      ret = ret.toUpperCase();
    } else {
      utils.send400(res, next, 'Please provide a valid case for datetime-rfc1123 case ' +
        '\'uppercase\', \'lowercase\' and not ' + util.inspect(req.params.case));
    }
    res.status(200).end(ret);
  });
    
  router.get('/min', function(req, res, next) {
    coverage["getDateTimeRfc1123MinUtc"]++;
    res.status(200).end('"Mon, 01 Jan 0001 00:00:00 GMT"');
  });
  
  router.get('/:scenario', function(req, res, next) {
    if (req.params.scenario === 'null') {
      coverage["getDateTimeRfc1123Null"]++;
      res.status(200).end();
    } else if (req.params.scenario === 'invalid') {
      coverage["getDateTimeRfc1123Invalid"]++;
      res.status(200).end('"Tue, 01 Dec 2000 00:00:0A ABC"');
    } else if (req.params.scenario === 'overflow') {
      coverage["getDateTimeRfc1123Overflow"]++;
      res.status(200).end('"Sat, 1 Jan 10000 00:00:00 GMT"');
    } else if (req.params.scenario === 'underflow') {
      coverage["getDateTimeRfc1123Underflow"]++;
      res.status(200).end('"Tue, 00 Jan 0000 00:00:00 GMT"');
    } else {
      res.status(400).send('Request path must contain a valid scenario: ' +
        '"null", "invalid", "overflow", "underflow". Provided value is : ', +
        util.inspect(req.params.scenario));
    }
  });
}

datetimeRfc1123.prototype.router = router;

module.exports = datetimeRfc1123;