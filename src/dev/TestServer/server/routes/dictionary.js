var express = require('express');
var router = express.Router();
var util = require('util');
var _ = require('underscore');
var utils = require('../util/utils')

var dictionary = function(coverage) {
    router.put('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'empty') {
            if (util.inspect(req.body) !== '{}') {
                utils.send400(res, next, "Did not like empty dictionary req '" + util.inspect(req.body) + "'");
            } else {
                coverage['putDictionaryEmpty']++;
                res.status(200).end();
            }
        }  else {
            utils.send400(res, next, 'Request path must contain empty');
        }
    });

    router.get('/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getDictionaryNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'empty') {
            coverage['getDictionaryEmpty']++;
            res.status(200).end('{}');
        } else if (req.params.scenario === 'invalid') {
            coverage['getDictionaryInvalid']++;
            res.status(200).end('{"key1": "val1", "key2", "val2"');
        } else if (req.params.scenario === 'nullvalue') {
            coverage['getDictionaryNullValue']++;
            res.status(200).end('{"key1" : null}');
        } else if (req.params.scenario === 'nullkey') {
            coverage['getDictionaryNullkey']++;
            res.status(200).end('{null : "val1"}');
        } else if (req.params.scenario === 'keyemptystring') {
            coverage['getDictionaryKeyEmptyString']++;
            res.status(200).end('{"" : "val1"}');
        } else {
            res.status(400).send('Request path must contain null or empty or invalid');
        }
    });

    router.get('/prim/:type/:scenario', function(req, res, next) {
        if (req.params.type == 'boolean') {
            if (req.params.scenario === 'tfft') {
                coverage['getDictionaryBooleanValid']++;
                res.status(200).end('{"0": true, "1": false, "2": false, "3": true }');
            } else if (req.params.scenario === 'true.null.false') {
                coverage['getDictionaryBooleanWithNull']++;
                res.status(200).end('{"0": true, "1": null, "2": false }');
            } else if (req.params.scenario === 'true.boolean.false') {
                coverage['getDictionaryBooleanWithString']++;
                res.status(200).end('{"0": true, "1": "boolean", "2": false}');
            } else {
                res.status(400).send('Request scenario for boolean primitive type must contain tfft or true.null.false or true.boolean.false');
            }
        } else if (req.params.type == 'integer') {
            if (req.params.scenario === '1.-1.3.300') {
                coverage['getDictionaryIntegerValid']++;
                res.status(200).end('{"0": 1, "1": -1, "2": 3, "3": 300}');
            } else if (req.params.scenario === '1.null.zero') {
                coverage['getDictionaryIntegerWithNull']++;
                res.status(200).end('{"0": 1, "1": null, "2": 0}');
            } else if (req.params.scenario === '1.integer.0') {
                coverage['getDictionaryIntegerWithString']++;
                res.status(200).end('{"0": 1, "1": "integer", "2": 0}');
            } else {
                res.status(400).send('Request scenario for integer primitive type must contain 1.-1.3.300 or 1.null.zero or 1.boolean.0');
            }
        } else if (req.params.type == 'long') {
            if (req.params.scenario === '1.-1.3.300') {
                coverage['getDictionaryLongValid']++;
                res.status(200).end('{"0": 1, "1": -1, "2": 3, "3": 300}');
            } else if (req.params.scenario === '1.null.zero') {
                coverage['getDictionaryLongWithNull']++;
                res.status(200).end('{"0": 1, "1": null, "2": 0}');
            } else if (req.params.scenario === '1.integer.0') {
                coverage['getDictionaryLongWithString']++;
                res.status(200).end('{"0": 1, "1": "integer", "2": 0}');
            } else {
                res.status(400).send('Request scenario for long primitive type must contain 1.-1.3.300 or 1.null.zero or 1.boolean.0');
            }
        } else if (req.params.type == 'float') {
            if (req.params.scenario === '0--0.01-1.2e20') {
                coverage['getDictionaryFloatValid']++;
                res.status(200).end('{"0": 0, "1": -0.01, "2": -1.2e20}');
            } else if (req.params.scenario === '0.0-null-1.2e20') {
                coverage['getDictionaryFloatWithNull']++;
                res.status(200).end('{"0": 0.0, "1": null, "2": -1.2e20}');
            } else if (req.params.scenario === '1.number.0') {
                coverage['getDictionaryFloatWithString']++;
                res.status(200).end('{"0": 1, "1": "number", "2": 0}');
            } else {
                res.status(400).send('Request scenario for float primitive type must contain 0--0.01-1.2e20 or 0.0-null-1.2e20 or 1.number.0');
            }
        } else if (req.params.type == 'double') {
            if (req.params.scenario === '0--0.01-1.2e20') {
                coverage['getDictionaryDoubleValid']++;
                res.status(200).end('{"0": 0, "1": -0.01, "2": -1.2e20}');
            } else if (req.params.scenario === '0.0-null-1.2e20') {
                coverage['getDictionaryDoubleWithNull']++;
                res.status(200).end('{"0": 0.0, "1": null, "2": -1.2e20}');
            } else if (req.params.scenario === '1.number.0') {
                coverage['getDictionaryDoubleWithString']++;
                res.status(200).end('{"0": 1, "1": "number", "2": 0}');
            } else {
                res.status(400).send('Request scenario for double primitive type must contain 0--0.01-1.2e20 or 0.0-null-1.2e20 or 1.number.0');
            }
        } else if (req.params.type == 'string') {
            if (req.params.scenario === 'foo1.foo2.foo3') {
                coverage['getDictionaryStringValid']++;
                res.status(200).end('{"0": "foo1", "1": "foo2", "2": "foo3"}');
            } else if (req.params.scenario === 'foo.null.foo2') {
                coverage['getDictionaryStringWithNull']++;
                res.status(200).end('{"0": "foo", "1": null, "2": "foo2" }');
            } else if (req.params.scenario === 'foo.123.foo2') {
                coverage['getDictionaryStringWithNumber']++;
                res.status(200).end('{"0": "foo", "1": 123, "2": "foo2"}');
            } else {
                res.status(400).send('Request scenario for float primitive type must contain foo1.foo2.foo3 or foo.null.foo2 or foo.123.foo2');
            }
        } else if (req.params.type == 'date') {
            if (req.params.scenario === 'valid') {
                coverage['getDictionaryDateValid']++;
                res.status(200).end('{"0": "2000-12-01", "1": "1980-01-02", "2": "1492-10-12"}');
            } else if (req.params.scenario === 'invalidnull') {
                coverage['getDictionaryDateWithNull']++;
                res.status(200).end('{"0": "2012-01-01", "1": null, "2": "1776-07-04"}');
            } else if (req.params.scenario === 'invalidchars') {
                coverage['getDictionaryDateWithInvalidChars']++;
                res.status(200).end('{"0": "2011-03-22", "1": "date"}');
            } else {
                res.status(400).send('Request scenario for date primitive type must contain valid or invalidnull or invalidchars');
            }
        } else if (req.params.type == 'date-time') {
            if (req.params.scenario === 'valid') {
                coverage['getDictionaryDateTimeValid']++;
                res.status(200).end('{"0": "2000-12-01t00:00:01z", "1": "1980-01-02T00:11:35+01:00", "2": "1492-10-12T10:15:01-08:00"}');
            } else if (req.params.scenario === 'invalidnull') {
                coverage['getDictionaryDateTimeWithNull']++;
                res.status(200).end('{"0": "2000-12-01t00:00:01z", "1": null}');
            } else if (req.params.scenario === 'invalidchars') {
                coverage['getDictionaryDateTimeWithInvalidChars']++;
                res.status(200).end('{"0": "2000-12-01t00:00:01z", "1": "date-time"}');
            } else {
                res.status(400).send('Request scenario for date-time primitive type must contain valid or invalidnull or invalidchars');
            }
        } else if (req.params.type == 'date-time-rfc1123') {
            if (req.params.scenario === 'valid') {
                coverage['getDictionaryDateTimeRfc1123Valid']++;
                res.status(200).end('{"0": "Fri, 01 Dec 2000 00:00:01 GMT", "1": "Wed, 02 Jan 1980 00:11:35 GMT", "2": "Wed, 12 Oct 1492 10:15:01 GMT"}');
            } else {
                res.status(400).send('Request scenario for date-time-rfc1123 primitive type must contain valid');
            }
        } else if (req.params.type == 'duration') {
            if (req.params.scenario === 'valid') {
                coverage['getDictionaryDurationValid']++;
                res.status(200).end('{"0": "P123DT22H14M12.011S", "1": "P5DT1H"}');
            } else {
                res.status(400).send('Request scenario for duration primitive type must contain valid');
            }            
        } else if (req.params.type == 'byte') {
            if (req.params.scenario === 'valid') {
                var bytes1 = new Buffer([255, 255, 255, 250]);
                var bytes2 = new Buffer([1, 2, 3]);
                var bytes3 = new Buffer([37, 41 , 67]);
                coverage['getDictionaryByteValid']++;
                res.status(200).end('{"0": "' + bytes1.toString('base64') + '", "1": "' + bytes2.toString('base64') + '", "2": "' +
                    bytes3.toString('base64') + '"}');
            } else if (req.params.scenario === 'invalidnull') {
                var bytesNull = new Buffer([171, 172, 173]);
                coverage['getDictionaryByteWithNull']++;
                res.status(200).end('{"0": "' + bytesNull.toString('base64') + '", "1": null}');
            } else {
                res.status(400).send('Request scenario for byte primitive type must contain valid or invalidnull');
            }
        } else if (req.params.type == 'base64url') {
            if (req.params.scenario === 'valid') {
                coverage['getDictionaryBase64Url']++;
                res.status(200).end('{"0": "YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjR1cmw", "1": "dGVzdCBzdHJpbmc", "2": "TG9yZW0gaXBzdW0"}');
            } else {
                res.status(400).send('Request scenario for base64url type must contain valid');
            }            
        } else {
            res.status(400).send('Request path must contain boolean or integer or float or double or string or date or date-time or byte or base64url');
        }
    });

    router.put('/prim/:type/:scenario', function(req, res, next) {
	if (req.params.type == 'boolean') {
            if (req.params.scenario === 'tfft') {
		    if (!_.isEqual(req.body, {"0": true, "1": false, "2": false, "3": true})) {
			utils.send400(res, next, "Did not like empty req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryBooleanValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for boolean primitive type must contain tfft or true.null.false or true.boolean.false');
	    }
	} else if (req.params.type == 'integer') {
            if (req.params.scenario === '1.-1.3.300') {
		    if (!_.isEqual(req.body, { "0": 1,  "1": -1,  "2": 3,  "3": 300})) {
			utils.send400(res, next, "Did not like integer dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryIntegerValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for integer primitive type must contain 1.-1.3.300');
	    }
	} else if (req.params.type == 'long') {
            if (req.params.scenario === '1.-1.3.300') {
		    if (!_.isEqual(req.body, {"0": 1, "1": -1, "2": 3, "3": 300})) {
			utils.send400(res, next, "Did not like long dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryLongValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for long primitive type must contain 1.-1.3.300');
	    }
	} else if (req.params.type == 'float') {
            if (req.params.scenario === '0--0.01-1.2e20') {
		    if (!_.isEqual(req.body, {"0": 0, "1": -0.01, "2": -1.2e20})) {
			utils.send400(res, next, "Did not like float dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryFloatValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for float primitive type must contain 0--0.01-1.2e20 ');
	    }
	} else if (req.params.type == 'double') {
            if (req.params.scenario === '0--0.01-1.2e20') {
		    if (!_.isEqual(req.body, {"0": 0, "1": -0.01, "2": -1.2e20})) {
			utils.send400(res, next, "Did not like double dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryDoubleValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for double primitive type must contain 0--0.01-1.2e20 ');
	    }
	} else if (req.params.type == 'string') {
            if (req.params.scenario === 'foo1.foo2.foo3') {
		    if (!_.isEqual(req.body, {"0": 'foo1', "1": 'foo2', "2": 'foo3'})) {
			utils.send400(res, next, "Did not like string dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryStringValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for string primitive type must contain foo1.foo2.foo3');
	    }
	} else if (req.params.type == 'date') {
            if (req.params.scenario === 'valid') {
		    if (!_.isEqual(req.body, {"0": '2000-12-01', "1": '1980-01-02', "2": '1492-10-12'})) {
			utils.send400(res, next, "Did not like date dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryDateValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for date primitive type must contain valid');
	    }
	} else if (req.params.type == 'date-time') {
            if (req.params.scenario === 'valid') {
        if ((_.isEqual(req.body, {"0": '2000-12-01T00:00:01Z', "1": '1980-01-01T23:11:35Z', "2": '1492-10-12T18:15:01Z'}))||
            (_.isEqual(req.body, {"0": '2000-12-01T00:00:01.000Z', "1": '1980-01-01T23:11:35.000Z', "2": '1492-10-12T18:15:01.000Z'}))) {
            coverage['putDictionaryDateTimeValid']++;
			  res.status(200).end();
		    } else {
              utils.send400(res, next, "Did not like date-time dictionary req '" + util.inspect(req.body) + "'");
		    }
	    } else {
		    res.status(400).send('Request scenario for date-time primitive type must contain valid');
	    }
    } else if (req.params.type == 'date-time-rfc1123') {
        if (req.params.scenario === 'valid') {
            if ((_.isEqual(req.body, {'0': 'Fri, 01 Dec 2000 00:00:01 GMT', '1': 'Wed, 02 Jan 1980 00:11:35 GMT', '2': 'Wed, 12 Oct 1492 10:15:01 GMT'}))) {
                coverage['putDictionaryDateTimeRfc1123Valid']++;
                res.status(200).end();
            } else {
              utils.send400(res, next, "Did not like date-time-rfc1123 dictionary req '" + util.inspect(req.body) + "'");
            }
        } else {
            res.status(400).send('Request scenario for date-time-rfc1123 primitive type must contain valid');
        }
    } else if (req.params.type == 'duration') {
        if (req.params.scenario === 'valid') {
            if (_.isEqual(req.body, {'0': 'P123DT22H14M12.011S', '1': 'P5DT1H'}) || _.isEqual(req.body, {'0': 'P123DT22H14M12.010999999998603S', '1': 'P5DT1H'})) {
                coverage['putDictionaryDurationValid']++;
                res.status(200).end();
            } else {
              utils.send400(res, next, "Did not like duration dictionary req '" + util.inspect(req.body) + "'");
            }
        } else {
            res.status(400).send('Request scenario for duration primitive type must contain valid');
        }
	} else if (req.params.type == 'byte') {
            if (req.params.scenario === 'valid') {
		var bytes1 = new Buffer([255, 255, 255, 250]);
		    var bytes2 = new Buffer([1, 2, 3]);
		    var bytes3 = new Buffer([37, 41 , 67]);
		    if (!_.isEqual(req.body, {"0": bytes1.toString('base64') , "1": bytes2.toString('base64') , "2": bytes3.toString('base64') })) {
			utils.send400(res, next, "Did not like byte[] dictionary req '" + util.inspect(req.body) + "'");
		    } else {
			coverage['putDictionaryByteValid']++;
			    res.status(200).end();
		    }
	    } else {
		    res.status(400).send('Request scenario for byte primitive type must contain valid ');
	    }
	} else {
		res.status(400).send('Request path must contain boolean or integer or float or double or string or date or date-time or byte');
	}
    });

    router.get('/complex/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getDictionaryComplexNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'empty') {
            coverage['getDictionaryComplexEmpty']++;
            res.status(200).end('{}');
        } else if (req.params.scenario === 'itemnull') {
            coverage['getDictionaryComplexItemNull']++;
            res.status(200).end('{"0": {"integer": 1, "string": "2"}, "1": null, "2": {"integer": 5, "string": "6"}}');
        } else if (req.params.scenario === 'itemempty') {
            coverage['getDictionaryComplexItemEmpty']++;
            res.status(200).end('{"0": {"integer": 1, "string": "2"}, "1": {}, "2": {"integer": 5, "string": "6"}}');
        } else if (req.params.scenario === 'valid') {
            coverage['getDictionaryComplexValid']++;
            res.status(200).end('{"0": {"integer": 1, "string": "2"}, "1": {"integer": 3, "string": "4"}, "2": {"integer": 5, "string": "6"}}');
        } else {
		utils.send400(res, next, 'Request path must contain null, empty, itemnull, itemempty, or valid for complex dictionary get scenarios.');
        }
    });

    router.put('/complex/:scenario', function(req, res, next) {
	if (req.params.scenario === 'valid') {
		if (_.isEqual(req.body, {"0": {'integer': 1, 'string': '2'}, "1": {'integer': 3, 'string': '4'}, "2": {'integer': 5, 'string': '6'}})) {
			coverage['putDictionaryComplexValid']++;
                res.status(200).end();
		} else {
			utils.send400(res, next, "Did not like complex dictionary req '" + util.inspect(req.body) + "'");
		}
        } else {
		utils.send400(res, next, 'Request path must contain valid for complex dictionary put scenarios.');
        }
    });

    router.get('/array/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getDictionaryArrayNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'empty') {
            coverage['getDictionaryArrayEmpty']++;
            res.status(200).end('{}');
        } else if (req.params.scenario === 'itemnull') {
            coverage['getDictionaryArrayItemNull']++;
            res.status(200).end('{"0": ["1", "2", "3"], "1": null, "2": ["7", "8", "9"]}');
        } else if (req.params.scenario === 'itemempty') {
            coverage['getDictionaryArrayItemEmpty']++;
            res.status(200).end('{"0": ["1", "2", "3"], "1": [], "2": ["7", "8", "9"]}');
        } else if (req.params.scenario === 'valid') {
            coverage['getDictionaryArrayValid']++;
            res.status(200).end('{"0": ["1", "2", "3"], "1": ["4", "5", "6"], "2": ["7", "8", "9"]}');
        } else {
		utils.send400(res, next, 'Request path must contain null, empty, itemnull, itemempty, or valid for dictionary of array get scenarios.')
        }
    });

    router.put('/array/:scenario', function(req, res, next) {
	if (req.params.scenario === 'valid') {
		if (_.isEqual(req.body, {"0": ['1', '2', '3'], "1": ['4', '5', '6'], "2": ['7', '8', '9']})) {
			coverage['putDictionaryArrayValid']++;
                res.status(200).end();
		} else {
			utils.send400(res, next, "Did not like dictionary of array req '" + util.inspect(req.body) + "'");
		}
        } else {
		utils.send400(res, next, 'Request path must contain valid for dictionary of array put scenarios.');
        }
    });

    router.get('/dictionary/:scenario', function(req, res, next) {
        if (req.params.scenario === 'null') {
            coverage['getDictionaryDictionaryNull']++;
            res.status(200).end();
        } else if (req.params.scenario === 'empty') {
            coverage['getDictionaryDictionaryEmpty']++;
            res.status(200).end('{}');
        } else if (req.params.scenario === 'itemnull') {
            coverage['getDictionaryDictionaryItemNull']++;
            res.status(200).end('{"0": {"1": "one", "2": "two", "3": "three"}, "1": null, "2": {"7": "seven", "8": "eight", "9": "nine"}}');
        } else if (req.params.scenario === 'itemempty') {
            coverage['getDictionaryDictionaryItemEmpty']++;
            res.status(200).end('{"0": {"1": "one", "2": "two", "3": "three"}, "1": {}, "2": {"7": "seven", "8": "eight", "9": "nine"}}');
        } else if (req.params.scenario === 'valid') {
            coverage['getDictionaryDictionaryValid']++;
            res.status(200).end('{"0": {"1": "one", "2": "two", "3": "three"}, "1": {"4": "four", "5": "five", "6": "six"}, "2": {"7": "seven", "8": "eight", "9": "nine"}}');
        } else {
		utils.send400(res, next, 'Request path must contain null, empty, itemnull, itemempty, or valid for dictionary dictionary get scenarios.');
        }
    });

    router.put('/dictionary/:scenario', function(req, res, next) {
	if (req.params.scenario === 'valid') {
		if (_.isEqual(req.body, {"0": {'1': 'one', '2': 'two', '3': 'three'}, "1": {'4': 'four', '5': 'five', '6': 'six'}, "2": {'7': 'seven', '8': 'eight', '9': 'nine'}})) {
			coverage['putDictionaryDictionaryValid']++;
                res.status(200).end();
		} else {
			utils.send400(res, next, "Did not like dictionary dictionary req '" + util.inspect(req.body) + "'");
		}
        } else {
		utils.send400(res, next, 'Request path must contain valid for dictionary dictionary put scenarios.');
        }
    });
};

dictionary.prototype.router = router;

module.exports = dictionary;
