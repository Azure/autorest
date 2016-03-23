var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')
var _ = require('underscore');
var array = function (coverage) {
  router.put('/:scenario', function (req, res, next) {
    if (req.params.scenario === 'empty') {
      if (util.inspect(req.body) !== '[]') {
        utils.send400(res, next, "Did not like empty req '" + util.inspect(req.body) + "'");
      } else {
        coverage['putArrayEmpty']++;
        res.status(200).end();
      }
    } else {
      utils.send400(res, next, 'Request path must contain empty');
    }
  });
  
  router.get('/:scenario', function (req, res, next) {
    if (req.params.scenario === 'null' || req.params.scenario === 'notProvided') {
      coverage['getArrayNull']++;
      res.status(200).end();
    } else if (req.params.scenario === 'empty') {
      coverage['getArrayEmpty']++;
      res.status(200).end('[]');
    } else if (req.params.scenario === 'invalid') {
      coverage['getArrayInvalid']++;
      res.status(200).end('[1, 2, 3');
    } else {
      res.status(400).send('Request path must contain null or empty or invalid');
    }

  });
  
  router.get('/prim/:type/:scenario', function (req, res, next) {
    if (req.params.type == 'boolean') {
      if (req.params.scenario === 'tfft') {
        coverage['getArrayBooleanValid']++;
        res.status(200).end('[ true, false, false, true]');
      } else if (req.params.scenario === 'true.null.false') {
        coverage['getArrayBooleanWithNull']++;
        res.status(200).end('[ true, null, false ]');
      } else if (req.params.scenario === 'true.boolean.false') {
        coverage['getArrayBooleanWithString']++;
        res.status(200).end('[true, \"boolean\", false]');
      } else {
        res.status(400).send('Request scenario for boolean primitive type must contain tfft or true.null.false or true.boolean.false');
      }
    } else if (req.params.type == 'integer') {
      if (req.params.scenario === '1.-1.3.300') {
        coverage['getArrayIntegerValid']++;
        res.status(200).end('[ 1, -1, 3, 300]');
      } else if (req.params.scenario === '1.null.zero') {
        coverage['getArrayIntegerWithNull']++;
        res.status(200).end('[ 1, null, 0 ]');
      } else if (req.params.scenario === '1.integer.0') {
        coverage['getArrayIntegerWithString']++;
        res.status(200).end('[1, \"integer\", 0]');
      } else {
        res.status(400).send('Request scenario for integer primitive type must contain 1.-1.3.300 or 1.null.zero or 1.boolean.0');
      }
    } else if (req.params.type == 'long') {
      if (req.params.scenario === '1.-1.3.300') {
        coverage['getArrayLongValid']++;
        res.status(200).end('[ 1, -1, 3, 300]');
      } else if (req.params.scenario === '1.null.zero') {
        coverage['getArrayLongWithNull']++;
        res.status(200).end('[ 1, null, 0 ]');
      } else if (req.params.scenario === '1.integer.0') {
        coverage['getArrayLongWithString']++;
        res.status(200).end('[1, \"integer\", 0]');
      } else {
        res.status(400).send('Request scenario for long primitive type must contain 1.-1.3.300 or 1.null.zero or 1.boolean.0');
      }
    } else if (req.params.type == 'float') {
      if (req.params.scenario === '0--0.01-1.2e20') {
        coverage['getArrayFloatValid']++;
        res.status(200).end('[ 0, -0.01, -1.2e20]');
      } else if (req.params.scenario === '0.0-null-1.2e20') {
        coverage['getArrayFloatWithNull']++;
        res.status(200).end('[ 0.0, null, -1.2e20 ]');
      } else if (req.params.scenario === '1.number.0') {
        coverage['getArrayFloatWithString']++;
        res.status(200).end('[1, \"number\", 0]');
      } else {
        res.status(400).send('Request scenario for float primitive type must contain 0--0.01-1.2e20 or 0.0-null-1.2e20 or 1.number.0');
      }
    } else if (req.params.type == 'double') {
      if (req.params.scenario === '0--0.01-1.2e20') {
        coverage['getArrayDoubleValid']++;
        res.status(200).end('[ 0, -0.01, -1.2e20]');
      } else if (req.params.scenario === '0.0-null-1.2e20') {
        coverage['getArrayDoubleWithNull']++;
        res.status(200).end('[ 0.0, null, -1.2e20 ]');
      } else if (req.params.scenario === '1.number.0') {
        coverage['getArrayDoubleWithString']++;
        res.status(200).end('[1, \"number\", 0]');
      } else {
        res.status(400).send('Request scenario for double primitive type must contain 0--0.01-1.2e20 or 0.0-null-1.2e20 or 1.number.0');
      }
    } else if (req.params.type == 'string') {
      if (req.params.scenario === 'foo1.foo2.foo3') {
        coverage['getArrayStringValid']++;
        res.status(200).end('[ \"foo1\", \"foo2\", \"foo3\"]');
      } else if (req.params.scenario === 'foo.null.foo2') {
        coverage['getArrayStringWithNull']++;
        res.status(200).end('[ \"foo\", null, \"foo2\" ]');
      } else if (req.params.scenario === 'foo.123.foo2') {
        coverage['getArrayStringWithNumber']++;
        res.status(200).end('[\"foo\", 123, \"foo2\"]');
      } else {
        res.status(400).send('Request scenario for float primitive type must contain foo1.foo2.foo3 or foo.null.foo2 or foo.123.foo2');
      }
    } else if (req.params.type == 'date') {
      if (req.params.scenario === 'valid') {
        coverage['getArrayDateValid']++;
        res.status(200).end('[\"2000-12-01\", \"1980-01-02\", \"1492-10-12\"]');
      } else if (req.params.scenario === 'invalidnull') {
        coverage['getArrayDateWithNull']++;
        res.status(200).end('[\"2012-01-01\", null, \"1776-07-04\"]');
      } else if (req.params.scenario === 'invalidchars') {
        coverage['getArrayDateWithInvalidChars']++;
        res.status(200).end('[\"2011-03-22\", \"date\"]');
      } else {
        res.status(400).send('Request scenario for date primitive type must contain valid or invalidnull or invalidchars');
      }
    } else if (req.params.type == 'uuid') {
      if (req.params.scenario === 'valid') {
        coverage['getArrayUuidValid']++;
        res.status(200).end('[\"6dcc7237-45fe-45c4-8a6b-3a8a3f625652\", \"d1399005-30f7-40d6-8da6-dd7c89ad34db\", \"f42f6aa1-a5bc-4ddf-907e-5f915de43205\"]');
      } else if (req.params.scenario === 'invalidchars') {
        coverage['getArrayUuidWithInvalidChars']++;
        res.status(200).end('[\"6dcc7237-45fe-45c4-8a6b-3a8a3f625652\", \"foo\"]');
      } else {
        res.status(400).send('Request scenario for uuid primitive type must contain valid or invalidchars');
      }
    } else if (req.params.type == 'date-time') {
      if (req.params.scenario === 'valid') {
        coverage['getArrayDateTimeValid']++;
        res.status(200).end('[\"2000-12-01t00:00:01z\", \"1980-01-02T01:11:35+01:00\", \"1492-10-12T02:15:01-08:00\"]');
      } else if (req.params.scenario === 'invalidnull') {
        coverage['getArrayDateTimeWithNull']++;
        res.status(200).end('[\"2000-12-01t00:00:01z\", null]');
      } else if (req.params.scenario === 'invalidchars') {
        coverage['getArrayDateTimeWithInvalidChars']++;
        res.status(200).end('[\"2000-12-01t00:00:01z\", \"date-time\"]');
      } else {
        res.status(400).send('Request scenario for date-time primitive type must contain valid or invalidnull or invalidchars');
      }
    } else if (req.params.type == 'date-time-rfc1123') {
      if (req.params.scenario === 'valid') {
        coverage['getArrayDateTimeRfc1123Valid']++;
        res.status(200).end('[\"Fri, 01 Dec 2000 00:00:01 GMT\", \"Wed, 02 Jan 1980 00:11:35 GMT\", \"Wed, 12 Oct 1492 10:15:01 GMT\"]');
      } else {
        res.status(400).send('Request scenario for date-time-rfc1123 primitive type must contain valid');
      }
    } else if (req.params.type == 'duration') {
      if (req.params.scenario === 'valid') {
        coverage['getArrayDurationValid']++;
        res.status(200).end('[\"P123DT22H14M12.011S\", \"P5DT1H0M0S\"]');
      } else {
        res.status(400).send('Request scenario for duration primitive type must contain valid');
      }
    } else if (req.params.type == 'byte') {
      if (req.params.scenario === 'valid') {
        var bytes1 = new Buffer([255, 255, 255, 250]);
        var bytes2 = new Buffer([1, 2, 3]);
        var bytes3 = new Buffer([37, 41, 67]);
        coverage['getArrayByteValid']++;
        res.status(200).end('[\"' + bytes1.toString('base64') + '\", \"' + bytes2.toString('base64') + '\", \"' +
                    bytes3.toString('base64') + '\"]');
      } else if (req.params.scenario === 'invalidnull') {
        var bytesNull = new Buffer([171, 172, 173]);
        coverage['getArrayByteWithNull']++;
        res.status(200).end('[\"' + bytesNull.toString('base64') + '\", null]');
      } else {
        res.status(400).send('Request scenario for byte primitive type must contain valid or invalidnull');
      }
    } else if (req.params.type == 'base64url') {
        if (req.params.scenario === 'valid') {
          coverage['getArrayBase64Url']++;
          res.status(200).end('[\"YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjR1cmw\", \"dGVzdCBzdHJpbmc\", \"TG9yZW0gaXBzdW0\"]');
        } else {
          res.status(400).send('Request scenario for base64url type must contain valid');
        }
    } else {
      res.status(400).send('Request path must contain boolean or integer or float or double or string or date or date-time or byte or base64url');
    }

  });
  
  router.put('/prim/:type/:scenario', function (req, res, next) {
    if (req.params.type == 'boolean') {
      if (req.params.scenario === 'tfft') {
        if (util.inspect(req.body) !== util.inspect([true, false, false, true])) {
          utils.send400(res, next, "Did not like empty req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayBooleanValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for boolean primitive type must contain tfft or true.null.false or true.boolean.false');
      }
    } else if (req.params.type == 'integer') {
      if (req.params.scenario === '1.-1.3.300') {
        if (util.inspect(req.body) !== util.inspect([1, -1, 3, 300])) {
          utils.send400(res, next, "Did not like integer array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayIntegerValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for integer primitive type must contain 1.-1.3.300');
      }
    } else if (req.params.type == 'long') {
      if (req.params.scenario === '1.-1.3.300') {
        if (util.inspect(req.body) !== util.inspect([1, -1, 3, 300])) {
          utils.send400(res, next, "Did not like long array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayLongValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for long primitive type must contain 1.-1.3.300');
      }
    } else if (req.params.type == 'float') {
      if (req.params.scenario === '0--0.01-1.2e20') {
        if (util.inspect(req.body) !== util.inspect([0, -0.01, -1.2e20])) {
          utils.send400(res, next, "Did not like float array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayFloatValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for float primitive type must contain 0--0.01-1.2e20 ');
      }
    } else if (req.params.type == 'double') {
      if (req.params.scenario === '0--0.01-1.2e20') {
        if (util.inspect(req.body) !== util.inspect([0, -0.01, -1.2e20])) {
          utils.send400(res, next, "Did not like double array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayDoubleValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for double primitive type must contain 0--0.01-1.2e20 ');
      }
    } else if (req.params.type == 'string') {
      if (req.params.scenario === 'foo1.foo2.foo3') {
        if (util.inspect(req.body) !== util.inspect(['foo1', 'foo2', 'foo3'])) {
          utils.send400(res, next, "Did not like string array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayStringValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for string primitive type must contain foo1.foo2.foo3');
      }
    } else if (req.params.type == 'date') {
      if (req.params.scenario === 'valid') {
        if (util.inspect(req.body) !== util.inspect(['2000-12-01', '1980-01-02', '1492-10-12'])) {
          utils.send400(res, next, "Did not like date array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayDateValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for date primitive type must contain valid');
      }
    } else if (req.params.type == 'uuid') {
      if (req.params.scenario === 'valid') {
        //uuid should be lowercase when converted to string
        if (util.inspect(req.body) !== util.inspect(['6dcc7237-45fe-45c4-8a6b-3a8a3f625652', 'd1399005-30f7-40d6-8da6-dd7c89ad34db', 'f42f6aa1-a5bc-4ddf-907e-5f915de43205'])) {
          utils.send400(res, next, "Did not like uuid array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayUuidValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for uuid primitive type must contain valid');
      }
    } else if (req.params.type == 'date-time') {
      if (req.params.scenario === 'valid') {
        if ((_.isEqual(req.body, ['2000-12-01T00:00:01Z', '1980-01-02T00:11:35Z', '1492-10-12T10:15:01Z'])) ||
                    (_.isEqual(req.body, ['2000-12-01T00:00:01.000Z', '1980-01-02T00:11:35.000Z', '1492-10-12T10:15:01.000Z']))) {
          coverage['putArrayDateTimeValid']++;
          res.status(200).end();
        } else {
          utils.send400(res, next, "Did not like date-time array req '" + util.inspect(req.body) + "'");
        }
      } else {
        res.status(400).send('Request scenario for date-time primitive type must contain valid');
      }
    } else if (req.params.type == 'date-time-rfc1123') {
      if (req.params.scenario === 'valid') {
        if (_.isEqual(req.body, ['Fri, 01 Dec 2000 00:00:01 GMT', 'Wed, 02 Jan 1980 00:11:35 GMT', 'Wed, 12 Oct 1492 10:15:01 GMT'])) {
          coverage['putArrayDateTimeRfc1123Valid']++;
          res.status(200).end();
        } else {
          utils.send400(res, next, "Did not like date-time-rfc1123 array req '" + util.inspect(req.body) + "'");
        }
      } else {
        res.status(400).send('Request scenario for date-time-rfc1123 primitive type must contain valid');
      }
    } else if (req.params.type == 'duration') {
      if (req.params.scenario === 'valid') {
        if (_.isEqual(req.body, ['P123DT22H14M12.011S', 'P5DT1H']) || _.isEqual(req.body, ['P123DT22H14M12.010999999998603S', 'P5DT1H'])) {
          coverage['putArrayDurationValid']++;
          res.status(200).end();
        } else {
          utils.send400(res, next, "Did not like duration array req '" + util.inspect(req.body) + "'");
        }
      } else {
        res.status(400).send('Request scenario for duration primitive type must contain valid');
      }
    } else if (req.params.type == 'byte') {
      if (req.params.scenario === 'valid') {
        var bytes1 = new Buffer([255, 255, 255, 250]);
        var bytes2 = new Buffer([1, 2, 3]);
        var bytes3 = new Buffer([37, 41, 67]);
        if (util.inspect(req.body) !== util.inspect([bytes1.toString('base64'), bytes2.toString('base64'), bytes3.toString('base64')])) {
          utils.send400(res, next, "Did not like byte[] array req '" + util.inspect(req.body) + "'");
        } else {
          coverage['putArrayByteValid']++;
          res.status(200).end();
        }
      } else {
        res.status(400).send('Request scenario for byte primitive type must contain valid ');
      }
    } else {
      res.status(400).send('Request path must contain boolean or integer or float or double or string or date or date-time or byte');
    }

  });
  
  router.get('/complex/:scenario', function (req, res, next) {
    if (req.params.scenario === 'null') {
      coverage['getArrayComplexNull']++;
      res.status(200).end();
    } else if (req.params.scenario === 'empty') {
      coverage['getArrayComplexEmpty']++;
      res.status(200).end('[]');
    } else if (req.params.scenario === 'itemnull') {
      coverage['getArrayComplexItemNull']++;
      res.status(200).end('[{\"integer\": 1, \"string\": \"2\"}, null, {\"integer\": 5, \"string\": \"6\"}]');
    } else if (req.params.scenario === 'itemempty') {
      coverage['getArrayComplexItemEmpty']++;
      res.status(200).end('[{\"integer\": 1, \"string\": \"2\"}, {}, {\"integer\": 5, \"string\": \"6\"}]');
    } else if (req.params.scenario === 'valid') {
      coverage['getArrayComplexValid']++;
      res.status(200).end('[{\"integer\": 1, \"string\": \"2\"}, {\"integer\": 3, \"string\": \"4\"}, {\"integer\": 5, \"string\": \"6\"}]');
    } else {
      utils.send400(res, next, 'Request path must contain null, empty, itemnull, itemempty, or valid for complex array get scenarios.')
    }
  });
  
  router.put('/complex/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (_.isEqual(req.body, [{
          'integer': 1,
          'string': '2'
        }, {
          'integer': 3,
          'string': '4'
        }, {
          'integer': 5,
          'string': '6'
        }])) {
        coverage['putArrayComplexValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex array req '" + util.inspect(req.body) + "'");
      }
    } else {
      utils.send400(res, next, 'Request path must contain valid for complex array put scenarios.');
    }
  });
  
  router.get('/array/:scenario', function (req, res, next) {
    if (req.params.scenario === 'null') {
      coverage['getArrayArrayNull']++;
      res.status(200).end();
    } else if (req.params.scenario === 'empty') {
      coverage['getArrayArrayEmpty']++;
      res.status(200).end('[]');
    } else if (req.params.scenario === 'itemnull') {
      coverage['getArrayArrayItemNull']++;
      res.status(200).end('[[\"1\", "2\", \"3\"], null, [\"7\", \"8\", \"9\"]]');
    } else if (req.params.scenario === 'itemempty') {
      coverage['getArrayArrayItemEmpty']++;
      res.status(200).end('[[\"1\", "2\", \"3\"], [], [\"7\", \"8\", \"9\"]]');
    } else if (req.params.scenario === 'valid') {
      coverage['getArrayArrayValid']++;
      res.status(200).end('[[\"1\", "2\", \"3\"], [\"4\", \"5\", \"6\"], [\"7\", \"8\", \"9\"]]');
    } else {
      utils.send400(res, next, 'Request path must contain null, empty, itemnull, itemempty, or valid for array of array get scenarios.')
    }
  });
  
  router.put('/array/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (_.isEqual(req.body, [
        ['1', '2', '3'],
        ['4', '5', '6'],
        ['7', '8', '9']
      ])) {
        coverage['putArrayArrayValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like array array req '" + util.inspect(req.body) + "'");
      }
    } else {
      utils.send400(res, next, 'Request path must contain valid for array of array put scenarios.');
    }
  });
  
  router.get('/dictionary/:scenario', function (req, res, next) {
    if (req.params.scenario === 'null') {
      coverage['getArrayDictionaryNull']++;
      res.status(200).end();
    } else if (req.params.scenario === 'empty') {
      coverage['getArrayDictionaryEmpty']++;
      res.status(200).end('[]');
    } else if (req.params.scenario === 'itemnull') {
      coverage['getArrayDictionaryItemNull']++;
      res.status(200).end('[{\"1\": \"one\", \"2\": \"two\", \"3\": \"three\"}, null, {\"7\": \"seven\", \"8\": \"eight\", \"9\": \"nine\"}]');
    } else if (req.params.scenario === 'itemempty') {
      coverage['getArrayDictionaryItemEmpty']++;
      res.status(200).end('[{\"1\": \"one\", \"2\": \"two\", \"3\": \"three\"}, {}, {\"7\": \"seven\", \"8\": \"eight\", \"9\": \"nine\"}]');
    } else if (req.params.scenario === 'valid') {
      coverage['getArrayDictionaryValid']++;
      res.status(200).end('[{\"1\": \"one\", \"2\": \"two\", \"3\": \"three\"}, {\"4\": \"four\", \"5\": \"five\", \"6\": \"six\"}, {\"7\": \"seven\", \"8\": \"eight\", \"9\": \"nine\"}]');
    } else {
      utils.send400(res, next, 'Request path must contain null, empty, itemnull, itemempty, or valid for dictionary array get scenarios.')
    }
  });
  
  router.put('/dictionary/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (_.isEqual(req.body, [{
          '1': 'one',
          '2': 'two',
          '3': 'three'
        }, {
          '4': 'four',
          '5': 'five',
          '6': 'six'
        }, {
          '7': 'seven',
          '8': 'eight',
          '9': 'nine'
        }])) {
        coverage['putArrayDictionaryValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex array req '" + util.inspect(req.body) + "'");
      }
    } else {
      utils.send400(res, next, 'Request path must contain valid for dictionary array put scenarios.');
    }
  });
}

array.prototype.router = router;

module.exports = array;