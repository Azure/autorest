var express = require('express');
var router = express.Router();
var util = require('util');
var _ = require('underscore');
var utils = require('../util/utils')

var complex = function (coverage) {
  /**
     * Put and get for basic complex classes.
     */
    router.put('/basic/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (_.isEqual(req.body, { "id": 2, "name": "abc", "color": "Magenta" })) {
        coverage['putComplexBasicValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like valid req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must specify scenario either "valid" or "empty"');
    }
  });
  
  router.get('/basic/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      coverage['getComplexBasicValid']++;
      res.status(200).end('{ "id": 2, "name": "abc", "color": "YELLOW" }');
    } else if (req.params.scenario === 'empty') {
      coverage['getComplexBasicEmpty']++;
      res.status(200).end('{ }');
    } else if (req.params.scenario === 'notprovided') {
      coverage['getComplexBasicNotProvided']++;
      res.status(200).end();
    } else if (req.params.scenario === 'null') {
      coverage['getComplexBasicNull']++;
      res.status(200).end('{ "id": null, "name": null }');
    } else if (req.params.scenario === 'invalid') {
      coverage['getComplexBasicInvalid']++;
      res.status(200).end('{ "id": "a", "name": "abc" }');
    } else {
      res.status(400).send('Request scenario must be valid, empty, null, notprovided, or invalid.');
    }
  });
  
  /**
     * Put and get for primitive
     */
    var intBody = { "field1": -1, "field2": 2 };
  var longBody = { "field1": 1099511627775, "field2": -999511627788 };
  var floatBody = { "field1": 1.05, "field2": -0.003 };
  var doubleBody = { "field1": 3e-100, "field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose": -0.000000000000000000000000000000000000000000000000000000005 };
  var doubleBodyInbound = { "field1": 3e-100, "field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose": -5e-57 };
  var boolBody = { "field_true": true, "field_false": false };
  var stringBody = { "field": "goodrequest", "empty": "", "null": null };
  var stringBodyInbound = { "field": "goodrequest", "empty": "" };
  var dateBody = { "field": "0001-01-01", "leap": "2016-02-29" };
  var datetimeBody = { "field": "0001-01-01T00:00:00Z", "now": "2015-05-18T18:38:00Z" };
  var datetimeRfc1123Body = { "field": "Mon, 01 Jan 0001 00:00:00 GMT", "now": "Mon, 18 May 2015 11:38:00 GMT" };
  var datetimeRfc1123BodyAlternate = { "field": "Mon, 01 Jan 1 00:00:00 GMT", "now": "Mon, 18 May 2015 11:38:00 GMT" };
  var datetimeRfc1123BodyAlternateWithSpaces = { "field": "Mon, 01 Jan    1 00:00:00 GMT", "now": "Mon, 18 May 2015 11:38:00 GMT" };
  var durationBody = { "field": "P123DT22H14M12.011S" };
  var durationBodyAlternate = { "field": "P123DT22H14M12.010999999998603S" };
  var datetimeBodyExact = { "field": "0001-01-01T00:00:00.000Z", "now": "2015-05-18T18:38:00.000Z" };
  var byteString = new Buffer([255, 254, 253, 252, 0, 250, 249, 248, 247, 246]).toString('base64');
  var byteBody = '{"field":"' + byteString + '"}';
  router.put('/primitive/:scenario', function (req, res, next) {
    if (req.params.scenario === 'integer') {
      if (_.isEqual(req.body, intBody)) {
        coverage['putComplexPrimitiveInteger']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like integer req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'long') {
      if (_.isEqual(req.body, longBody)) {
        coverage['putComplexPrimitiveLong']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like long req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'float') {
      if (_.isEqual(req.body, floatBody)) {
        coverage['putComplexPrimitiveFloat']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like float req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'double') {
      if (_.isEqual(req.body, doubleBodyInbound)) {
        coverage['putComplexPrimitiveDouble']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like double req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'bool') {
      if (_.isEqual(req.body, boolBody)) {
        coverage['putComplexPrimitiveBool']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like bool req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'string') {
      console.log(JSON.stringify(req.body));
      if (_.isEqual(req.body, stringBody) || _.isEqual(req.body, stringBodyInbound)) {
        coverage['putComplexPrimitiveString']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like string req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'date') {
      if (_.isEqual(req.body, dateBody)) {
        coverage['putComplexPrimitiveDate']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like date req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'datetime') {
      if (_.isEqual(req.body, datetimeBody) || _.isEqual(req.body, datetimeBodyExact)) {
        coverage['putComplexPrimitiveDateTime']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like datetime req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'datetimerfc1123') {
      if (_.isEqual(req.body, datetimeRfc1123Body) || _.isEqual(req.body, datetimeRfc1123BodyAlternate) || _.isEqual(req.body, datetimeRfc1123BodyAlternateWithSpaces)) {
        coverage['putComplexPrimitiveDateTimeRfc1123']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like datetimerfc1123 req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'duration') {
      if (_.isEqual(req.body, durationBody) || _.isEqual(req.body, durationBodyAlternate)) {
        coverage['putComplexPrimitiveDuration']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like duration req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'byte') {
      if (JSON.stringify(req.body) === byteBody) {
        coverage['putComplexPrimitiveByte']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like byte req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must provide a valid primitive type.');
    }
  });
  
  router.get('/primitive/:scenario', function (req, res, next) {
    if (req.params.scenario === 'integer') {
      coverage['getComplexPrimitiveInteger']++;
      res.status(200).end(JSON.stringify(intBody));
    } else if (req.params.scenario === 'long') {
      coverage['getComplexPrimitiveLong']++;
      res.status(200).end(JSON.stringify(longBody));
    } else if (req.params.scenario === 'float') {
      coverage['getComplexPrimitiveFloat']++;
      res.status(200).end(JSON.stringify(floatBody));
    } else if (req.params.scenario === 'double') {
      coverage['getComplexPrimitiveDouble']++;
      res.status(200).end(JSON.stringify(doubleBody));
    } else if (req.params.scenario === 'bool') {
      coverage['getComplexPrimitiveBool']++;
      res.status(200).end(JSON.stringify(boolBody));
    } else if (req.params.scenario === 'string') {
      coverage['getComplexPrimitiveString']++;
      res.status(200).end(JSON.stringify(stringBody));
    } else if (req.params.scenario === 'date') {
      coverage['getComplexPrimitiveDate']++;
      res.status(200).end(JSON.stringify(dateBody));
    } else if (req.params.scenario === 'datetime') {
      coverage['getComplexPrimitiveDateTime']++;
      res.status(200).end(JSON.stringify(datetimeBody));
    } else if (req.params.scenario === 'datetimerfc1123') {
      coverage['getComplexPrimitiveDateTimeRfc1123']++;
      res.status(200).end(JSON.stringify(datetimeRfc1123Body));
    } else if (req.params.scenario === 'duration') {
      coverage['getComplexPrimitiveDuration']++;
      res.status(200).end(JSON.stringify(durationBody));
    } else if (req.params.scenario === 'byte') {
      coverage['getComplexPrimitiveByte']++;
      res.status(200).end(byteBody);
    } else {
      utils.send400(res, next, 'Must provide a valid primitive type scenario.');
    }
  });
  
  /**
     * Put and get for array properties.
     */
    var arrayValidBody = '{"array":["1, 2, 3, 4","",null,"&S#$(*Y","The quick brown fox jumps over the lazy dog"]}';
  router.put('/array/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (JSON.stringify(req.body) === arrayValidBody) {
        coverage['putComplexArrayValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex array req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'empty') {
      if (JSON.stringify(req.body) === '{"array":[]}') {
        coverage['putComplexArrayEmpty']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex array req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.get('/array/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      coverage['getComplexArrayValid']++;
      res.status(200).end(arrayValidBody);
    } else if (req.params.scenario === 'empty') {
      coverage['getComplexArrayEmpty']++;
      res.status(200).end('{"array":[]}');
    } else if (req.params.scenario === 'notprovided') {
      coverage['getComplexArrayNotProvided']++;
      res.status(200).end('{}');
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  /**
     * Put and get for typed dictionary properties.
     */
    var dictionaryValidBody = '{"defaultProgram":{"txt":"notepad","bmp":"mspaint","xls":"excel","exe":"","":null}}';
  router.put('/dictionary/typed/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (_.isEqual(req.body, JSON.parse(dictionaryValidBody))) {
        coverage['putComplexDictionaryValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex dictionary req " + util.inspect(req.body));
      }
    } else if (req.params.scenario === 'empty') {
      if (JSON.stringify(req.body) === '{"defaultProgram":{}}') {
        coverage['putComplexDictionaryEmpty']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex array req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.get('/dictionary/typed/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      coverage['getComplexDictionaryValid']++;
      res.status(200).end(dictionaryValidBody);
    } else if (req.params.scenario === 'empty') {
      coverage['getComplexDictionaryEmpty']++;
      res.status(200).end('{"defaultProgram":{}}');
    } else if (req.params.scenario === 'null') {
      coverage['getComplexDictionaryNull']++;
      res.status(200).end('{"defaultProgram":null}');
    } else if (req.params.scenario === 'notprovided') {
      coverage['getComplexDictionaryNotProvided']++;
      res.status(200).end('{}');
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  /**
     * Put and get for untyped dictionary properties.
     */
    router.put('/dictionary/untyped/:scenario', function (req, res, next) {
    res.status(501).end("Untyped dictionaries are not supported for now.");
  });
  
  router.get('/dictionary/untyped/:scenario', function (req, res, next) {
    res.status(501).end("Untyped dictionaries are not supported for now.");
  });
  
  /**
     * Put and get for inhertiance.
     */
    var siamese = '{"breed":"persian","color":"green","hates":[{"food":"tomato","id":1,"name":"Potato"},{"food":"french fries","id":-1,"name":"Tomato"}],"id":2,"name":"Siameeee"}';
  
  router.put('/inheritance/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      if (_.isEqual(req.body, JSON.parse(siamese))) {
        coverage['putComplexInheritanceValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex inheritance req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.get('/inheritance/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      coverage['getComplexInheritanceValid']++;
      res.status(200).end(siamese);
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  /**
     * Put and get for polymorphism.
     */
    var rawFish =
 {
    'fishtype': 'salmon',
    'location': 'alaska',
    'iswild': true,
    'species': 'king',
    'length': 1.0,
    'siblings': [
      {
        'fishtype': 'shark',
        'age': 6,
        'birthday': '2012-01-05T01:00:00Z',
        'length': 20.0,
        'species': 'predator',
      },
      {
        'fishtype': 'sawshark',
        'age': 105,
        'birthday': '1900-01-05T01:00:00Z',
        'length': 10.0,
        'picture': new Buffer([255, 255, 255, 255, 254]).toString('base64'),
        'species': 'dangerous',
      },
      {
        'fishtype': 'goblin',
        'age': 1,
        'birthday': '2015-08-08T00:00:00Z',
        'length': 30.0,
        'species': 'scary',
        'jawsize': 5
      }
    ]
  };
  
  router.put('/polymorphism/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      console.log(JSON.stringify(req.body, null, 4));
      console.log(JSON.stringify(rawFish, null, 4));
      if (_.isEqual(utils.coerceDate(req.body), rawFish)) {
        coverage['putComplexPolymorphismValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex polymorphism req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.get('/polymorphism/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      coverage['getComplexPolymorphismValid']++;
      res.status(200).end(JSON.stringify(rawFish));
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.put('/polymorphism/missingrequired/invalid', function (req, res, next) {
    utils.send400(res, next, 'Reached server in scenario: /complex/polymorphism/missingrequired/invalid, and should not have - since required fields are missing from the request, the client should not be able to send it.')
  })
  
  /**
     * Put and get for recursive reference.
     */
    var bigfishRaw = {
    "fishtype": "salmon",
    "location": "alaska",
    "iswild": true,
    "species": "king",
    "length": 1,
    "siblings": [
      {
        "fishtype": "shark",
        "age": 6,
        'birthday': '2012-01-05T01:00:00Z',
        "species": "predator",
        "length": 20,
        "siblings": [
          {
            "fishtype": "salmon",
            "location": "atlantic",
            "iswild": true,
            "species": "coho",
            "length": 2,
            "siblings": [
              {
                "fishtype": "shark",
                "age": 6,
                'birthday': '2012-01-05T01:00:00Z',
                "species": "predator",
                "length": 20
              },
              {
                "fishtype": "sawshark",
                "age": 105,
                'birthday': '1900-01-05T01:00:00Z',
                'picture': new Buffer([255, 255, 255, 255, 254]).toString('base64'),
                "species": "dangerous",
                "length": 10
              }
            ]
          },
          {
            "fishtype": "sawshark",
            "age": 105,
            'birthday': '1900-01-05T01:00:00Z',
            'picture': new Buffer([255, 255, 255, 255, 254]).toString('base64'),
            "species": "dangerous",
            "length": 10,
            "siblings": []
          }
        ]
      },
      {
        "fishtype": "sawshark",
        "age": 105,
        'birthday': '1900-01-05T01:00:00Z',
        'picture': new Buffer([255, 255, 255, 255, 254]).toString('base64'),
        "species": "dangerous",
        "length": 10, "siblings": []
      }
    ]
  };
  
  
  router.put('/polymorphicrecursive/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      console.log(JSON.stringify(req.body, null, 4));
      console.log(JSON.stringify(bigfishRaw, null, 4));
      if (_.isEqual(utils.coerceDate(req.body), bigfishRaw)) {
        coverage['putComplexPolymorphicRecursiveValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like complex polymorphic recursive req " + util.inspect(req.body));
      }
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.get('/polymorphicrecursive/:scenario', function (req, res, next) {
    if (req.params.scenario === 'valid') {
      coverage['getComplexPolymorphicRecursiveValid']++;
      res.status(200).end(JSON.stringify(bigfishRaw));
    } else {
      utils.send400(res, next, 'Must provide a valid scenario.');
    }
  });
  
  router.get('/readonlyproperty/valid', function (req, res, next) {
    res.status(200).end(JSON.stringify({ "id": "1234", "size": 2 }));
  });
  
  router.put('/readonlyproperty/valid', function (req, res, next) {
    if (req.body) {
      if (typeof req.body.id == "undefined") {
        coverage["putComplexReadOnlyPropertyValid"]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'id is readonly');
      }
    }
  });
};

complex.prototype.router = router;

module.exports = complex;