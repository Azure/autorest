// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var duration = function(coverage, optionalCoverage) {

    //TODO: It looks like ISO8601 doesn't cover negative durations (so there is no standard)... omitting for now
    // router.put('/negativeduration', function(req, res, next) {
        // if (req.body === '-P123DT22H14M12.011S') {
            // coverage["putDurationNegative"]++;
            // res.status(200).end();
        // } else {
            // utils.send400(res, next, "Did not like the value provided for negative duration " + util.inspect(req.body));
        // }        
    // });

    router.put('/positiveduration', function(req, res, next) {
        //For some reason moment.js doesn't quite get the right time value out (due to what looks like floating point issues)
        //so we have to check for two possible times
        if (req.body === 'P123DT22H14M12.011S' || req.body === "P123DT22H14M12.010999999998603S") {
            coverage["putDurationPositive"]++;
            res.status(200).end();
        } else {
            utils.send400(res, next, "Did not like the value provided for positive duration " + util.inspect(req.body));
        }
    });
    
    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage["getDurationNull"]++;
            res.status(200).end();
        } else if (req.params.scenario === 'invalid') {
            coverage["getDurationInvalid"]++;
            res.status(200).end('"123ABC"');
        } else if (req.params.scenario === 'positiveduration') {
            coverage["getDurationPositive"]++;
            res.status(200).end('"P3Y6M4DT12H30M5S"');
        //TODO: It looks like ISO8601 doesn't cover negative durations (so there is no standard)... omitting for now
        // } else if (req.params.scenario === 'negativeduration') {
            // coverage["getDurationNegative"]++;
            // res.status(200).end('"-P3Y6M4DT12H30M5S"');
        } else {
            res.status(400).send('Request path must contain a valid scenario: ' +
                '"null", "invalid", "positiveduration", "negativeduration". Provided value is : ', +
                util.inspect(req.params.scenario));
        }

    });
}

duration.prototype.router = router;

module.exports = duration;