var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')

var scenarioMap = {
  "true": "True",
  "false": "False",
  "1000000": "Positive",
  "-1000000": "Negative",
  "10000000000": "Positive",
  "-10000000000": "Negative",
  "1.034E+20": "Positive",
  "-1.034E-20": "Negative",
  "9999999.999": "Positive",
  "-9999999.999": "Negative",
  "begin!*'();:@ &=+$,/?#[]end": "UrlEncoded",
  "multibyte": "MultiByte",
  "empty": "Empty",
  "null": "Null",
  "2012-01-01": "Valid",
  "2012-01-01T01:01:01Z": "Valid",
  "green color" : "Valid",
  "bG9yZW0" : "Base64Url",
  "1460505600": "UnixTime",
  "ArrayPath1,begin!*'();:@ &=+$,/?#[]end,,": "CSVInPath"
};

var typeMap = {
  "bool": "Bool",
  "int": "Int",
  "long": "Long",
  "float": "Float",
  "double": "Double",
  "string": "String",
  "byte": "Byte",
  "date": "Date",
  "datetime": "DateTime",
  "enum" : "Enum",
  "array": "Array"
};

var getScenarioName = function (type, scenario) {
  console.log('received type "' + type + '" and scenario "' + scenario + '"\n');
  var parsedType = typeMap[type];
  var parsedScenario = scenarioMap[scenario];
  if (!parsedScenario || !parsedType) {
    return null;
  }

  console.log('Got parsed type "' + parsedType + '" and parsed scenario "' + parsedScenario + '"\n');
  return '' + parsedType + parsedScenario;
};

var validateArrayPath = function (arrayValue, separator) {
  console.log('received array value "' + arrayValue + '" separator "' + separator + '"');
  return (arrayValue === "ArrayPath1" + separator + "begin!*'();:@ &=+$,/?#[]end" + separator + separator);
};

var paths = function (coverage) {
  router.get('/:type/empty', function (req, res, next) {
    console.log("inside router\n");
    var type = req.params.type;
    var scenario = "empty";

    var test = getScenarioName(type, scenario);
    if (test === null) {
      console.log("test was null\n");
      utils.send400(res, next, 'Unable to parse scenario \"\/paths\/' + type + '\/' + scenario + '\"');
    } else if (scenario === "empty") {
      console.log("in empty test\n");
      coverage['UrlPaths' + test]++;
      res.status(200).end();
    } else {
      console.log('Empty Failure!\n');
      utils.send400(res, next, 'Unable to find matching empty scenario for type "' + type + '"');
    }
  });

  router.get('/:type/:scenario/:wireParameter', function (req, res, next) {
    console.log("inside router\n");

    var type = req.params.type;
    var scenario = req.params.scenario;
    var wireParameter = req.params.wireParameter;
    var test = getScenarioName(type, scenario);
    var bytes = new Buffer(constants.MULTIBYTE_BUFFER);

    if (type === 'enum' || type === 'date' || type === 'array' ||
           type === 'datetime' ||
           scenario === 'multibyte' ||
           (type === 'string' &&
           scenario.indexOf('begin') === 0) ||
           scenario === 'bG9yZW0') {
      scenario = '"' + scenario + '"';
      wireParameter = '"' + wireParameter + '"';
    }

    scenario = JSON.parse(scenario);
    wireParameter = JSON.parse(wireParameter);
   
    if (test === null) {
      console.log("test was null\n");
      utils.send400(res, next, 'Unable to parse scenario \"\/paths\/' + type + '\/' + scenario + '\"');
    } else if (scenario === "empty" && (wireParameter !== '' && wireParameter !== null)) {
      console.log("in empty test\n");
      utils.send400(res, next, 'Empty scenario must have empty parameter instead of \"' + wireParameter + '\"');
    } else if (type === 'string') {
      if (scenario === wireParameter) {
        console.log("Success!\n");
        coverage['UrlPaths' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed string scenario \"' + scenario + '\" does not match wire parameter \"' + wireParameter + '\"');
      }
    } else if (type === 'array') {
      if (scenario === wireParameter && validateArrayPath(wireParameter, ',')) {
        console.log("Success!\n");
        coverage['UrlPaths' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed enum scenario \"' + scenario + '\" does not match wire parameter \"' + wireParameter + '\"');
      }
    } else if (type === 'enum') {
      if (scenario === wireParameter) {
        console.log("Success!\n");
        coverage['UrlPaths' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed enum scenario \"' + scenario + '\" does not match wire parameter \"' + wireParameter + '\"');
      }
    } else if (type === 'byte') {
      if (scenario === 'multibyte' && wireParameter === bytes.toString("base64")) {
        console.log("Success!\n");
        coverage['UrlPaths' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed byte scenario \"' + wireParameter + '\" does not match expected encoded string \"' + bytes.toString("base64") + '\"');
      }
    } else if (type === 'datetime') {
      if (utils.coerceDate(wireParameter) === scenario) {
        console.log("Success!\n");
        coverage['UrlPaths' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed date-time scenario \"' + utils.coerceDate(wireParameter) + '\" does not match expected date string \"' + scenario +'\"');
      }
    } else if (scenario !== wireParameter) {
      console.log("mismatched parameters\n");
      utils.send400(res, next, 'Expected path parameter \"' + scenario + '\" does not match wire parameter \"' + wireParameter + '\"');
    } else {
      console.log("Success!\n");
      coverage['UrlPaths' + test]++;
      res.status(200).end();
    }
  });
}

paths.prototype.router = router;

module.exports = paths;