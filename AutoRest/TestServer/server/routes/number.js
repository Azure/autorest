var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

var number = function(coverage) {
    router.put('/big/:format/:value', function(req, res, next) {
        if (req.params.format === 'float') {
            if (req.params.value === '3.402823e+20' && req.body === 3.402823e+20) {
                coverage['putFloatBigScientificNotation']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for big float in the req " + util.inspect(req.body));
            }
        } else if (req.params.format === 'double') {
            if (req.params.value === '2.5976931e+101' && req.body === 2.5976931e+101) {
                coverage['putDoubleBigScientificNotation']++;
                res.status(200).end();
            } else if (req.params.value === '99999999.99' && req.body === 99999999.99) {
                coverage['putDoubleBigPositiveDecimal']++;
                res.status(200).end();
            } else if (req.params.value === '-99999999.99' && req.body === -99999999.99) {
                coverage['putDoubleBigNegativeDecimal']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for big double in the req " + util.inspect(req.body));
            }
		} else if (req.params.format === 'decimal') {
            if (req.params.value === '2.5976931e+101' && req.body === 2.5976931e+101) {
                coverage['putDecimalBig']++;
                res.status(200).end();
            } else if (req.params.value === '99999999.99' && req.body === 99999999.99) {
                coverage['putDecimalBigPositiveDecimal']++;
                res.status(200).end();
            } else if (req.params.value === '-99999999.99' && req.body === -99999999.99) {
                coverage['putDecimalBigNegativeDecimal']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for big decimal in the req " + util.inspect(req.body));
            }
        } else {
            utils.send400(res, next, "Please use either float, double or decimal in the req " + util.inspect(req.params.format));
        }
    });

    router.get('/big/:format/:value', function(req, res, next) {
        if (req.params.format === 'float') {
            if (req.params.value === '3.402823e+20') {
                coverage['getFloatBigScientificNotation']++;
                res.status(200).end('3.402823e+20');
            } else {
                utils.send400(res, next, "Did not like the value provided for big float in the req " + util.inspect(req.params.value));
            }
        } else if (req.params.format === 'double') {
            if (req.params.value === '2.5976931e+101') {
                coverage['getDoubleBigScientificNotation']++;
                res.status(200).end('2.5976931e+101');
            } else if (req.params.value === '99999999.99') {
                coverage['getDoubleBigPositiveDecimal']++;
                res.status(200).end('99999999.99');
            } else if (req.params.value === '-99999999.99') {
                coverage['getDoubleBigNegativeDecimal']++;
                res.status(200).end('-99999999.99');
            } else {
                utils.send400(res, next, "Did not understand the value provided for big double in the req " + util.inspect(req.params.value));
            }
		} else if (req.params.format === 'decimal') {
            if (req.params.value === '2.5976931e+101') {
                coverage['getDecimalBig']++;
                res.status(200).end('2.5976931e+101');
            } else if (req.params.value === '99999999.99') {
                coverage['getDecimalBigPositiveDecimal']++;
                res.status(200).end('99999999.99');
            } else if (req.params.value === '-99999999.99') {
                coverage['getDecimalBigNegativeDecimal']++;
                res.status(200).end('-99999999.99');
            } else {
                utils.send400(res, next, "Did not understand the value provided for big decimal in the req " + util.inspect(req.params.value));
            }
        } else {
            utils.send400(res, next, "Please use either float, double or decimal in the req " + util.inspect(req.params.format));
        }
    });

    router.put('/small/:format/:value', function(req, res, next) {
        if (req.params.format === 'float') {
            if (req.params.value === '3.402823e-20' && req.body === 3.402823e-20) {
                coverage['putFloatSmallScientificNotation']++;
                res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for small float in the req " + util.inspect(req.body));
            }
        } else if (req.params.format === 'double') {
            if (req.params.value === '2.5976931e-101' && req.body === 2.5976931e-101) {
                coverage['putDoubleSmallScientificNotation']++;
                    res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for small double in the req " + util.inspect(req.body));
            }
		} else if (req.params.format === 'decimal') {
            if (req.params.value === '2.5976931e-101' && req.body === 2.5976931e-101) {
                coverage['putDecimalSmall']++;
                    res.status(200).end();
            } else {
                utils.send400(res, next, "Did not like the value provided for small decimal in the req " + util.inspect(req.body));
            }
        } else {
            utils.send400(res, next, "Please use either float, double or decimal in the req " + util.inspect(req.params.format));
        }
    });

    router.get('/small/:format/:value', function(req, res, next) {
        if (req.params.format === 'float') {
            if (req.params.value === '3.402823e-20') {
                coverage['getFloatSmallScientificNotation']++;
                res.status(200).end('3.402823e-20');
            } else {
                utils.send400(res, next, "Did not like the value provided for small float in the req " + util.inspect(req.params.value));
            }
        } else if (req.params.format === 'double') {
            if (req.params.value === '2.5976931e-101') {
                coverage['getDoubleSmallScientificNotation']++;
                res.status(200).end('2.5976931e-101');
            } else {
                utils.send400(res, next, "Did not like the value provided for small double in the req " + util.inspect(req.params.value));
            }
		} else if (req.params.format === 'decimal') {
            if (req.params.value === '2.5976931e-101') {
                coverage['getDecimalSmall']++;
                res.status(200).end('2.5976931e-101');
            } else {
                utils.send400(res, next, "Did not like the value provided for small decimal in the req " + util.inspect(req.params.value));
            }
        } else {
            utils.send400(res, next, "Please use either float, double or decimal in the req " + util.inspect(req.params.format));
        }
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getNumberNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'invalidfloat') {
            coverage['getFloatInvalid']++;
            res.status(200).end('2147483656.090096789909j');
        } else if (req.params.scenario === 'invaliddouble') {
            coverage['getDoubleInvalid']++;
            res.status(200).end('9223372036854775910.980089k');
		} else if (req.params.scenario === 'invaliddecimal') {
			coverage['getDecimalInvalid']++;
            res.status(200).end('9223372036854775910.980089k');
        } else {
            res.status(400).send('Request path must contain true or false');
        }

    });
}

number.prototype.router = router;

module.exports = number;