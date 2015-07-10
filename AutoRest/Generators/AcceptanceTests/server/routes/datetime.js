var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var datetime = function(coverage, optionalCoverage) {
    optionalCoverage['putDateTimeMaxLocalPositiveOffset'] = 0;
    optionalCoverage['putDateTimeMaxLocalNegativeOffset']= 0;
    optionalCoverage['putDateTimeMinLocalPositiveOffset'] = 0;
    optionalCoverage['putDateTimeMinLocalNegativeOffset']= 0;
        router.put('/max/:type', function(req, res, next) {
        if (req.params.type === 'utc') {
            if (req.body === '9999-12-31T23:59:59.9999999Z') {
                coverage['putDateTimeMaxUtc']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for max datetime in the req " + util.inspect(req.body));
            }
        } else if (req.params.type === 'localpositiveoffset') {
            if (req.body === '9999-12-31T09:59:59.9999999Z') {
                optionalCoverage['putDateTimeMaxLocalPositiveOffset']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for max datetime in the req " + util.inspect(req.body));
            }
        } else if (req.params.type === 'localnegativeoffset') {
            if (req.body === '9999-12-31T23:59:59.9999999-14:00') {
                optionalCoverage['putDateTimeMaxLocalNegativeOffset']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for max datetime in the req " + util.inspect(req.body));
            }
        } else {
            utils.send400(res, next, 'Please provide a valid datetime type \'utc\', ' +
                '\'localpositiveoffset\', \'localnegativeoffset\' and not ' +
                util.inspect(req.params.type));
        }
    });

    router.get('/max/:type/:case', function(req, res, next) {
        var ret;
        var scenario;
        if (req.params.type === 'utc') {
            scenario = "getDateTimeMaxUtc";
            ret = '"9999-12-31T23:59:59.9999999Z"';
        } else if (req.params.type === 'localpositiveoffset') {
            scenario = "getDateTimeMaxLocalPositiveOffset";
            ret = '"9999-12-31T23:59:59.9999999+14:00"';
        } else if (req.params.type === 'localnegativeoffset') {
            scenario = "getDateTimeMaxLocalNegativeOffset";
            ret = '"9999-12-31T23:59:59.9999999-14:00"';
        } else {
            utils.send400(res, next, 'Please provide a valid datetime type \'utc\', ' +
                '\'localpositiveoffset\', \'localnegativeoffset\' and not ' +
                util.inspect(req.params.type));
        }
        if (req.params.case === 'lowercase') {
            coverage[scenario + "Lowercase"]++;
            ret = ret.toLowerCase();
        } else if (req.params.case === 'uppercase') {
            coverage[scenario + "Uppercase"]++;
            ret = ret.toUpperCase();
        } else {
            utils.send400(res, next, 'Please provide a valid case for datetime case ' +
                '\'uppercase\', \'lowercase\' and not ' + util.inspect(req.params.case));
        }
        res.status(200).end(ret);
    });

    router.put('/min/:type', function(req, res, next) {
        if (req.params.type === 'utc') {
            if (req.body === '0001-01-01T00:00:00Z') {
                coverage["putDateTimeMinUtc"]++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for min datetime in the req " + util.inspect(req.body));
            }
        } else if (req.params.type === 'localpositiveoffset') {
            if (req.body === '0001-01-01T10:00:00Z' || req.body === '0001-01-01T00:00:00+14:00') {
                optionalCoverage["putDateTimeMinLocalPositiveOffset"]++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for min datetime in the req " + util.inspect(req.body));
            }
        } else if (req.params.type === 'localnegativeoffset') {
            if (req.body === '0001-01-01T14:00:00Z' || req.body === '0001-01-01T00:00:00-14:00') {
                optionalCoverage["putDateTimeMinLocalNegativeOffset"]++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for min datetime in the req " + util.inspect(req.body));
            }
        } else {
            utils.send400(res, next, 'Please provide a valid datetime type \'utc\', ' +
                '\'localpositiveoffset\', \'localnegativeoffset\' and not ' +
                util.inspect(req.params.type));
        }
    });

    router.get('/min/:type', function(req, res, next) {
        if (req.params.type === 'utc') {
            coverage["getDateTimeMinUtc"]++;
            res.status(200).end('"0001-01-01T00:00:00Z"');
        } else if (req.params.type === 'localpositiveoffset') {
            coverage["getDateTimeMinLocalPositiveOffset"]++;
            res.status(200).end('"0001-01-01T00:00:00+14:00"');
        } else if (req.params.type === 'localnegativeoffset') {
            coverage["getDateTimeMinLocalNegativeOffset"]++;
            res.status(200).end('"0001-01-01T00:00:00-14:00"');
        } else {
            utils.send400(res, next, 'Please provide a valid datetime type \'utc\', ' +
                '\'localpositiveoffset\', \'localnegativeoffset\' and not ' +
                util.inspect(req.params.type));
        }
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage["getDateTimeNull"]++;
            res.status(200).end();
        } else if (req.params.scenario === 'invalid') {
            coverage["getDateTimeInvalid"]++;
            res.status(200).end('"201O-18-90D00:89:56.999AAAAX"');
        } else if (req.params.scenario === 'overflow') {
            coverage["getDateTimeOverflow"]++;
            res.status(200).end('"9999-12-31T23:59:59.9999999-14:00"');
        } else if (req.params.scenario === 'underflow') {
            coverage["getDateTimeUnderflow"]++;
            res.status(200).end('"0000-00-00T00:00:00.0000000+00:00"');
        } else {
            res.status(400).send('Request path must contain a valid scenario: ' +
                '"null", "invaliddate", "overflowdate", "underflowdate". Provided value is : ', +
                util.inspect(req.params.scenario));
        }

    });
}

datetime.prototype.router = router;

module.exports = datetime;