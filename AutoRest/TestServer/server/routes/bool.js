var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var bool = function(coverage) {
    router.put('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'true') {
            if (req.body !== true) {
                utils.send400(res, next, "Did not like true req " + util.inspect(req.body));
            } else {
                coverage['putBoolTrue']++;
                res.status(200).end();
            }
        } else if (req.params.scenario === 'false') {
            if (req.body !== false) {
                utils.send400(res, next, "Did not like false req " + util.inspect(req.body));
            } else {
                coverage['putBoolFalse']++;
                res.status(200).end();
            }
        } else {
            utils.send400(res, next, 'Request path must contain true or false');
        }
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'true') {
            coverage['getBoolTrue']++;
            res.status(200).end('true');
        } else if (req.params.scenario === 'false') {
            coverage['getBoolFalse']++;
            res.status(200).end('false');
        } else if (req.params.scenario === 'null') {
            coverage['getBoolNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'invalid') {
            coverage['getBoolInvalid']++;
            res.status(200).end('true1');
        } else {
            res.status(400).send('Request path must contain true or false');
        }

    });
}

bool.prototype.router = router;

module.exports = bool;