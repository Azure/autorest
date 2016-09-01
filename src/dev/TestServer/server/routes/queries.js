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
  "green color": "Valid"
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
  "enum" : "Enum"
};

var queryParameterMap = {
  "bool": "boolQuery",
  "int": "intQuery",
  "long": "longQuery",
  "float": "floatQuery",
  "double": "doubleQuery",
  "string": "stringQuery",
  "byte": "byteQuery",
  "date": "dateQuery",
  "datetime": "dateTimeQuery",
  "enum": "enumQuery"
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
}

var getQueryParameterName = function (type) {
  console.log('received type "' + type + '"\n');
  var queryParam = queryParameterMap[type];

  if (!queryParam) {
    return null;
  }

  console.log('Got parsed query parameter name "' + queryParam + '\n');
  return '' + queryParam;
}

var validateArrayQuery = function (arrayValue, separator) {
    var testValue = arrayValue;
    if (Array.isArray(arrayValue))
    {
        testValue = arrayValue.toString()
    }
    console.log('received array value "' + testValue + '" separator "' + separator + '"');
    return (testValue === "ArrayQuery1" + separator + "begin!*'();:@ &=+$,/?#[]end" + separator + separator);
}

var queries = function (coverage) {
  router.get('/:type/empty', function (req, res, next) {
    console.log("inside router\n");
    var type = req.params.type;
    var scenario = "empty";
    var queryName = getQueryParameterName(type);

    var test = getScenarioName(type, scenario);
    var queryParamCount = Object.keys(req.query).length;
    if (test === null) {
      console.log("test was null\n");
      utils.send400(res, next, 'Unable to parse scenario \"\/paths\/' + type + '\/' + scenario + '\"');
    } else if (scenario === "empty" && queryParamCount == 1 && req.query[queryName] === '') {
      console.log("in empty test\n");
      coverage['UrlQueries' + test]++;
      res.status(200).end();
    } else {
      console.log('Null Failure!\n');
      utils.send400(res, next, 'Failed null test for type "' + type + '" received query parameter "' + util.inspect(req.query) + '"');
    }
  });

  router.get('/:type/null', function (req, res, next) {
    console.log("inside router\n");
    var type = req.params.type;
    var scenario = "null";
    var queryName = getQueryParameterName(type);

    var test = getScenarioName(type, scenario);
    if (test === null) {
      console.log("test was null\n");
      utils.send400(res, next, 'Unable to parse scenario \"\/paths\/' + type + '\/' + scenario + '\"');
    } else if (scenario === "null" && Object.keys(req.query).length == 0) {
      console.log("in null test\n");
      coverage['UrlQueries' + test]++;
      res.status(200).end();
    } else {
      console.log('Null Failure!\n');
      utils.send400(res, next, 'Failed null test for type "' + type + '" received query parameter "' + util.inspect(req.query) + '"');
    }
  });

  router.get('/array/:format/string/:scenario', function (req, res, next) {
    console.log("inside router\n");
    var type = req.params.type;
    var scenario = req.params.scenario;
    var format = req.params.format;

    var test = getScenarioName(type, scenario);
    if (format === 'csv') {
      console.log("In csv test\n");
      if (scenario === 'null' && Object.keys(req.query).length == 0) {
        coverage['UrlQueriesArrayCsvNull']++;
        res.status(200).end();
      } else if (scenario === 'empty' && Object.keys(req.query).length == 1 && req.query.arrayQuery === '') {
        coverage['UrlQueriesArrayCsvEmpty']++;
        res.status(200).end();
      } else if ((scenario === 'valid') && Object.keys(req.query).length == 1 && validateArrayQuery(req.query.arrayQuery, ',')) {
        coverage['UrlQueriesArrayCsvValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed csv array scenario format "' + format + '", scenario "' + scenario + '"');
      }
    } else if (format === 'multi') {
        console.log("In multi test\n");
        if (scenario === 'null' && Object.keys(req.query).length == 0) {
            coverage['UrlQueriesArrayMultiNull']++;
            res.status(200).end();
        } else if (scenario === 'empty' && Object.keys(req.query).length == 1 && req.query.arrayQuery === '') {
        coverage['UrlQueriesArrayMultiEmpty']++;
        res.status(200).end();
            } else if ((scenario === 'valid') && Object.keys(req.query).length == 1 && validateArrayQuery(req.query.arrayQuery, ',')) {
            //Note: comma is used as a seperator to test multi format with becuase Array.toString returns comma seperated list
            coverage['UrlQueriesArrayMultiValid']++;
            res.status(200).end();
    } else {
            utils.send400(res, next, 'Failed csv array scenario format "' + format + '", scenario "' + scenario + '"');
    }
    } else if (format === 'ssv' && scenario === 'valid') {
      console.log("in ssv test\n");
      if ((scenario === 'valid') && Object.keys(req.query).length == 1 && validateArrayQuery(req.query.arrayQuery, ' ')) {
        coverage['UrlQueriesArraySsvValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed ssv array scenario format "' + format + '", scenario "' + scenario + '"');
      }
    } else if (format === 'tsv' && scenario === 'valid') {
      console.log("in tsv test\n");
      if ((scenario === 'valid') && Object.keys(req.query).length == 1 && validateArrayQuery(req.query.arrayQuery, '\t')) {
        coverage['UrlQueriesArrayTsvValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed tsv array scenario format "' + format + '", scenario "' + scenario + '"');
      }
    } else if (format === 'pipes' && scenario === 'valid') {
      console.log("in pipes test\n");
      if ((scenario === 'valid') && Object.keys(req.query).length == 1 && validateArrayQuery(req.query.arrayQuery, '|')) {
        coverage['UrlQueriesArrayPipesValid']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed pipes array scenario format "' + format + '", scenario "' + scenario + '"');
      }
    } else {
      console.log('Array Failure!\n');
      utils.send400(res, next, 'Unable to find matching Array scenario for format "' + format + '" scenario "' + scenario + '"');
    }
  });

  router.get('/:type/:scenario', function (req, res, next) {
    var type = req.params.type;
    var scenario = req.params.scenario;
    var queryName = getQueryParameterName(type);
    var wireParameter = req.query[queryName];
    var test = getScenarioName(type, scenario);
    console.log('inside main function with values type "' + type + '" scenario "' + scenario +
            '" queryName "' + queryName + '" wireParameter "' + wireParameter + '"\n');
    var bytes = new Buffer(constants.MULTIBYTE_BUFFER);

    if (type === 'enum' || type === 'date' ||
           type === 'datetime' ||
           scenario === 'multibyte' ||
           (type === 'string' &&
           scenario.indexOf('begin') === 0)) {
      scenario = '"' + scenario + '"';
      wireParameter = '"' + wireParameter + '"';
    }

    scenario = JSON.parse(scenario);
    wireParameter = JSON.parse(wireParameter);

    if (test === null) {
      console.log("test was null\n");
      utils.send400(res, next, 'Unable to parse scenario \"\/paths\/' + type + '\/' + scenario + '\"');
    } else if (scenario === "null" && (wireParameter)) {
      console.log("in null test\n");
      utils.send400(res, next, 'Null scenario must have empty query parameter instead of \"' + wireParameter + '\"');
    } else if (scenario === "empty" && (wireParameter !== '' && wireParameter !== null)) {
      console.log("in empty test\n");
      utils.send400(res, next, 'Empty scenario must have empty parameter instead of \"' + wireParameter + '\"');
    } else if (type === 'string' || type === 'date' || type === 'enum') {
      if (scenario === wireParameter) {
        console.log("Success!\n");
        coverage['UrlQueries' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed ' + type + ' scenario \"' + scenario + '\" does not match wire parameter \"' + wireParameter + '\"');
      }
    } else if (type === 'byte') {
      if (scenario === 'multibyte' && wireParameter === bytes.toString("base64")) {
        console.log("Success!\n");
        coverage['UrlQueries' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed byte scenario \"' + wireParameter + '\" does not match expected encoded string \"' + bytes.toString("base64") + '\"');
      }
    } else if (type === 'datetime') {
      if (utils.coerceDate(wireParameter) === scenario) {
        console.log("Success!\n");
        coverage['UrlQueries' + test]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Failed date-time scenario \"' + utils.coerceDate(wireParameter) + '\" does not match expected date string \"' + scenario +'\"');
      }
    } else if (scenario === wireParameter) {
      console.log("Success!\n");
      coverage['UrlQueries' + test]++;
      res.status(200).end();
    } else {
      console.log("mismatched parameters\n");
      utils.send400(res, next, 'Expected query parameter \"' + scenario + '\" does not match wire parameter \"' + wireParameter + '\"');
    }
  });
}

queries.prototype.router = router;

module.exports = queries;