var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var integer = function(coverage) {
    router.put('/max/:bits', function(req, res, next) {
        var bits = parseInt(req.params.bits, 10);
        if (bits === 32) {
            if (parseInt(req.body, 10) !== Math.pow(2, bits - 1) - 1) {
                utils.send400(res, next, "Did not like the value provided for max signed 32 bit in the req " + util.inspect(req.body));
            } else {
                coverage['putIntegerMax']++;
                res.status(200).end();
            }
        } else if (bits === 64) {
            if (req.body === 9223372036854776000) {
                coverage['putLongMax']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for max signed 64 bit in the req " + util.inspect(req.body));
            }
        } else {
            utils.send400(res, next, "Please use either 64 or 32 bits in the req " + util.inspect(req.body));
        }
    });

    router.put('/min/:bits', function(req, res, next) {
        var bits = parseInt(req.params.bits, 10);
        if (bits === 32) {
            if (parseInt(req.body, 10) !== -Math.pow(2, bits - 1)) {
                utils.send400(res, next, "Did not like the value provided for min signed 32 bit in the req " + util.inspect(req.body));
            } else {
                coverage['putIntegerMin']++;
                res.status(200).end();
            }
        } else if (bits === 64) {
            if (req.body === -9223372036854776000) {
                coverage['putLongMin']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for min signed 64 bit in the req " + util.inspect(req.body));
            }
        } else {
            utils.send400(res, next, "Please use either 64 or 32 bits in the req " + util.inspect(req.body));
        }
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getIntegerNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'invalid') {
            coverage['getIntegerInvalid']++;
            res.status(200).end('123jkl');
        } else if (req.params.scenario === 'overflowint32') {
            coverage['getIntegerOverflow']++;
            res.status(200).end('2147483656');
        } else if (req.params.scenario === 'underflowint32') {
            coverage['getIntegerUnderflow']++;
            res.status(200).end('-2147483656');
        } else if (req.params.scenario === 'overflowint64') {
            coverage['getLongOverflow']++;
            res.status(200).end('9223372036854775910');
        } else if (req.params.scenario === 'underflowint64') {
            coverage['getLongUnderflow']++;
            res.status(200).end('-9223372036854775910');
        } else if (req.params.scenario === 'unixtime') {
            coverage['getUnixTime']++;
            res.status(200).end('1460505600');
        } else if (req.params.scenario === 'invalidunixtime') {
            coverage['getInvalidUnixTime']++;
            res.status(200).end('123jkl');
        } else if (req.params.scenario === 'nullunixtime') {
            coverage['getNullUnixTime']++;
            res.status(200).end();
        } else {
            res.status(400).send('Request path must contain true or false');
        }
    });
    
    router.put('/unixtime', function(req, res, next) {
          if (req.body != 1460505600) {
              utils.send400(res, next, "Did not like the value provided for unixtime in the req " + util.inspect(req.body));
          } else {
              coverage['putUnixTime']++;
              res.status(200).end();
          }
    });
}

integer.prototype.router = router;

module.exports = integer;