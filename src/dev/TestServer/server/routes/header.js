var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils');

var header = function (coverage, optionalCoverage) {
  optionalCoverage['HeaderParameterProtectedKey'] = 0;
  optionalCoverage['CustomHeaderInRequest'] = 0;
  router.post('/param/:scenario', function (req, res, next) {
    if (req.params.scenario === "existingkey") {
      if (req.get("User-Agent") === "overwrite") {
        coverage['HeaderParameterExistingKey']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like scenario \"" + req.params.scenario + "\" with value " + req.get("User-Agent"));
      }
    } else if (req.params.scenario === "protectedkey") {
      if (req.get("Content-Type") !== "text/html") {
        optionalCoverage['HeaderParameterProtectedKey']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, "Did not like scenario \"" + req.params.scenario + "\" with value " + req.get("Content-Type"));
      }
    } else {
      utils.send400(res, next, "Did not like scenario \"" + req.params.scenario);
    }
  });

  router.post('/custom/x-ms-client-request-id/9C4D50EE-2D56-4CD3-8152-34347DC9F2B0', function (req, res, next) {
    if (req.get("x-ms-client-request-id").toLowerCase() === "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0".toLowerCase()) {
      optionalCoverage['CustomHeaderInRequest']++;
      res.status(200).end();
    } else {
      utils.send400(res, next, "Did not like client request id \"" + req.get("x-ms-client-request-id"));
    }
  });

  router.post('/response/:scenario', function (req, res, next) {
    if (req.params.scenario === "existingkey") {
      coverage['HeaderResponseExistingKey']++;
      res.status(200).set("User-Agent", "overwrite").end();
    } else if (req.params.scenario === "protectedkey") {
      coverage['HeaderResponseProtectedKey']++;
      res.status(200).set("Content-Type", "text/html").end();
    } else {
      utils.send400(res, next, "Did not like scenario \"" + req.params.scenario);
    }
  });

  router.post('/param/prim/:type', function (req, res, next) {
    var scenario = req.get("scenario");
    var value = req.get("value");
    switch (req.params.type) {
      case "integer":
        if (scenario === "positive") {
          if (parseInt(value) === 1) {
            coverage['HeaderParameterIntegerPositive']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "negative") {
          if (parseInt(value) === -2) {
            coverage['HeaderParameterIntegerNegative']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like integer scenario \"" + scenario + "\" with value " + value);
      case "long":
        if (scenario === "positive") {
          if (parseInt(value) === 105) {
            coverage['HeaderParameterLongPositive']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "negative") {
          if (parseInt(value) === -2) {
            coverage['HeaderParameterLongNegative']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like long scenario \"" + scenario + "\" with value " + value);
      case "float":
        if (scenario === "positive") {
          if (parseFloat(value) === 0.07) {
            coverage['HeaderParameterFloatPositive']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "negative") {
          if (parseFloat(value) === -3.0) {
            coverage['HeaderParameterFloatNegative']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like float scenario \"" + scenario + "\" with value " + value);
      case "double":
        if (scenario === "positive") {
          if (parseFloat(value) === 7e120) {
            coverage['HeaderParameterDoublePositive']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "negative") {
          if (parseFloat(value) === -3.0) {
            coverage['HeaderParameterDoubleNegative']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like double scenario \"" + scenario + "\" with value " + value);
      case "bool":
        if (scenario === "true") {
          if (value === "true") {
            coverage['HeaderParameterBoolTrue']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "false") {
          if (value === "false") {
            coverage['HeaderParameterBoolFalse']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like bool scenario \"" + scenario + "\" with value " + value);
      case "string":
        if (scenario === "valid") {
          if (value === "The quick brown fox jumps over the lazy dog") {
            coverage['HeaderParameterStringValid']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "null") {
          if (value === null || value === undefined) {
            coverage['HeaderParameterStringNull']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "empty") {
          if (value === "" || value === null || value === undefined) {
            coverage['HeaderParameterStringEmpty']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like string scenario \"" + scenario + "\" with value " + value);
      case "enum":
        if (scenario === "valid") {
          if (value === "GREY") {
            coverage['HeaderParameterEnumValid']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "null") {
          if (value === null || value === undefined) {
            coverage['HeaderParameterEnumNull']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like string scenario \"" + scenario + "\" with value " + value);
      case "date":
        if (scenario === "valid") {
          if (value === "2010-01-01") {
            coverage['HeaderParameterDateValid']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "min") {
          if (value === "0001-01-01") {
            coverage['HeaderParameterDateMin']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like date scenario \"" + scenario + "\" with value " + value);
      case "datetime":
        if (scenario === "valid") {
          if (utils.coerceDate(value) === "2010-01-01T12:34:56Z") {
            coverage['HeaderParameterDateTimeValid']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "min") {
          if (utils.coerceDate(value) === "0001-01-01T00:00:00Z") {
            coverage['HeaderParameterDateTimeMin']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like datetime scenario \"" + scenario + "\" with value " + value);
      case "datetimerfc1123":
        if (scenario === "valid") {
          if (value === "Fri, 01 Jan 2010 12:34:56 GMT") {
            coverage['HeaderParameterDateTimeRfc1123Valid']++;
            res.status(200).end();
            break;
          }
        } else if (scenario === "min") {
          if (value === "Mon, 01 Jan 0001 00:00:00 GMT" || value == "Mon, 01 Jan 1 00:00:00 GMT" || value == "Mon, 01 Jan    1 00:00:00 GMT") {
            coverage['HeaderParameterDateTimeRfc1123Min']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like datetimerfc1123 scenario \"" + scenario + "\" with value " + value);
      case "duration":
        if (scenario === "valid") {
          //For some reason moment.js doesn't quite get the right time value out (due to what looks like floating point issues)
          //so we have to check for two possible times
          if (value === "P123DT22H14M12.011S" || value == "P123DT22H14M12.010999999998603S") {
            coverage['HeaderParameterDurationValid']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like duration scenario \"" + scenario + "\" with value " + value);
      case "byte":
        var bytes = new Buffer(constants.MULTIBYTE_BUFFER);
        if (scenario === "valid") {
          if (value === bytes.toString('base64')) {
            coverage['HeaderParameterBytesValid']++;
            res.status(200).end();
            break;
          }
        }
        utils.send400(res, next, "Did not like byte scenario \"" + scenario + "\" with value " + value);
      default:
        utils.send400(res, next, 'Must provide a valid primitive type.');
    }
  });

  router.post('/response/prim/:type', function (req, res, next) {
    var scenario = req.get("scenario");
    var value = req.get("value");
    switch (req.params.type) {
      case "integer":
        if (scenario === "positive") {
          coverage['HeaderResponseIntegerPositive']++;
          res.status(200).set('value', 1).end();
          break;
        } else if (scenario === "negative") {
          coverage['HeaderResponseIntegerNegative']++;
          res.status(200).set('value', -2).end();
          break;
        }
        utils.send400(res, next, "Did not like integer scenario \"" + scenario + "\" with value " + value);
      case "long":
        if (scenario === "positive") {
          coverage['HeaderResponseLongPositive']++;
          res.status(200).set('value', 105).end();
          break;
        } else if (scenario === "negative") {
          coverage['HeaderResponseLongNegative']++;
          res.status(200).set('value', -2).end();
          break;
        }
        utils.send400(res, next, "Did not like long scenario \"" + scenario + "\" with value " + value);
      case "float":
        if (scenario === "positive") {
          coverage['HeaderResponseFloatPositive']++;
          res.status(200).set('value', 0.07).end();
          break;
        } else if (scenario === "negative") {
          coverage['HeaderResponseFloatNegative']++;
          res.status(200).set('value', -3.0).end();
          break;
        }
        utils.send400(res, next, "Did not like float scenario \"" + scenario + "\" with value " + value);
      case "double":
        if (scenario === "positive") {
          coverage['HeaderResponseDoublePositive']++;
          res.status(200).set('value', 7e120).end();
          break;
        } else if (scenario === "negative") {
          coverage['HeaderResponseDoubleNegative']++;
          res.status(200).set('value', -3.0).end();
          break;
        }
        utils.send400(res, next, "Did not like double scenario \"" + scenario + "\" with value " + value);
      case "bool":
        if (scenario === "true") {
          coverage['HeaderResponseBoolTrue']++;
          res.status(200).set('value', true).end();
          break;
        } else if (scenario === "false") {
          coverage['HeaderResponseBoolFalse']++;
          res.status(200).set('value', false).end();
          break;
        }
        utils.send400(res, next, "Did not like bool scenario \"" + scenario + "\" with value " + value);
      case "string":
        if (scenario === "valid") {
          coverage['HeaderResponseStringValid']++;
          res.status(200).set('value', "The quick brown fox jumps over the lazy dog").end();
          break;
        } else if (scenario === "null") {
          coverage['HeaderResponseStringNull']++;
          res.status(200).set('value', null).end();
          break;
        } else if (scenario === "empty") {
          coverage['HeaderResponseStringEmpty']++;
          res.status(200).set('value', "").end();
          break;
        }
        utils.send400(res, next, "Did not like string scenario \"" + scenario + "\" with value " + value);
      case "enum":
        if (scenario === "valid") {
          coverage['HeaderResponseEnumValid']++;
          res.status(200).set('value', "GREY").end();
          break;
        } else if (scenario === "null") {
          coverage['HeaderResponseEnumNull']++;
          res.status(200).set('value', '').end();
          break;
        }
        utils.send400(res, next, "Did not like enum scenario \"" + scenario + "\" with value " + value);
      case "date":
        if (scenario === "valid") {
          coverage['HeaderResponseDateValid']++;
          res.status(200).set('value', "2010-01-01").end();
          break;
        } else if (scenario === "min") {
          coverage['HeaderResponseDateMin']++;
          res.status(200).set('value', "0001-01-01").end();
          break;
        }
        utils.send400(res, next, "Did not like date scenario \"" + scenario + "\" with value " + value);
      case "datetime":
        if (scenario === "valid") {
          coverage['HeaderResponseDateTimeValid']++;
          res.status(200).set('value', "2010-01-01T12:34:56Z").end();
          break;
        } else if (scenario === "min") {
          coverage['HeaderResponseDateTimeMin']++;
          res.status(200).set('value', "0001-01-01T00:00:00Z").end();
          break;
        }
        utils.send400(res, next, "Did not like datetime scenario \"" + scenario + "\" with value " + value);
    case "datetimerfc1123":
        if (scenario === "valid") {
          coverage['HeaderResponseDateTimeRfc1123Valid']++;
          res.status(200).set('value', "Fri, 01 Jan 2010 12:34:56 GMT").end();
          break;
        } else if (scenario === "min") {
          coverage['HeaderResponseDateTimeRfc1123Min']++;
          res.status(200).set('value', "Mon, 01 Jan 0001 00:00:00 GMT").end();
          break;
        }
        utils.send400(res, next, "Did not like datetimerfc1123 scenario \"" + scenario + "\" with value " + value);
      case "duration":
        if (scenario === "valid") {
          coverage['HeaderResponseDurationValid']++;
          res.status(200).set('value', "P123DT22H14M12.011S").end();
          break;
        }
        utils.send400(res, next, "Did not like duration scenario \"" + scenario + "\" with value " + value);
      case "byte":
        var bytes = new Buffer(constants.MULTIBYTE_BUFFER);
        if (scenario === "valid") {
          coverage['HeaderResponseBytesValid']++;
          res.status(200).set('value', bytes.toString('base64')).end();
          break;
        }
        utils.send400(res, next, "Did not like byte scenario \"" + scenario + "\" with value " + value);
      default:
        utils.send400(res, next, 'Must provide a valid primitive type.');
    }
  });
};

header.prototype.router = router;

module.exports = header;
