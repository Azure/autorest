var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var date = function(coverage) {
    router.put('/max', function(req, res, next) {
        if (req.body === '9999-12-31') {
            coverage['putDateMax']++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the value provided for max date in the req " + util.inspect(req.body));
        }
    });

    router.get('/max', function(req, res, next) {
        coverage['getDateMax']++;
        res.status(200).end('"9999-12-31"');
    });

    router.put('/min', function(req, res, next) {
        if (req.body === '0001-01-01') {
            coverage['putDateMin']++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the value provided for min date in the req " + util.inspect(req.body));
        }
    });

    router.get('/min', function(req, res, next) {
        coverage['getDateMin']++;
        res.status(200).end('"0001-01-01"');
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getDateNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'invaliddate') {
            coverage['getDateInvalid']++;
            res.status(200).end('"201O-18-90"');
        } else if (req.params.scenario === 'overflowdate') {
            coverage['getDateOverflow']++;
            res.status(200).end('"10000000000-12-31"');
        } else if (req.params.scenario === 'underflowdate') {
            coverage['getDateUnderflow']++;
            res.status(200).end('"0000-00-00"');
        } else {
            res.status(400).send('Request path must contain a valid scenario: ' +
                '"null", "invaliddate", "overflowdate", "underflowdate". Provided value is : ', +
                util.inspect(req.params.scenario));
        }

    });
}

date.prototype.router = router;

module.exports = date;