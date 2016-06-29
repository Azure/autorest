var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')



var specials = function (coverage) {
  coverage['AzureSubscriptionMethodLocalValid'] = 0;
  coverage['AzureSubscriptionMethodGlobalValid'] = 0;
  coverage['AzureSubscriptionMethodGlobalNotProvidedValid'] = 0;
  coverage['AzureSubscriptionPathLocalValid'] = 0;
  coverage['AzureSubscriptionPathGlobalValid'] = 0;
  coverage['AzureSubscriptionSwaggerLocalValid'] = 0;
  coverage['AzureSubscriptionSwaggerGlobalValid'] = 0;
  coverage['AzureApiVersionMethodLocalNull'] = 0;
  coverage['AzureApiVersionMethodLocalValid'] = 0;
  coverage['AzureApiVersionMethodGlobalValid'] = 0;
  coverage['AzureApiVersionMethodGlobalNotProvidedValid'] = 0;
  coverage['AzureApiVersionPathLocalValid'] = 0;
  coverage['AzureApiVersionPathGlobalValid'] = 0;
  coverage['AzureApiVersionSwaggerLocalValid'] = 0;
  coverage['AzureApiVersionSwaggerGlobalValid'] = 0;
  coverage['AzureMethodPathUrlEncoding'] = 0;
  coverage['AzurePathPathUrlEncoding'] = 0;
  coverage['AzureSwaggerPathUrlEncoding'] = 0;
  coverage['AzureMethodQueryUrlEncoding'] = 0;
  coverage['AzurePathQueryUrlEncoding'] = 0;
  coverage['AzureSwaggerQueryUrlEncoding'] = 0;
  coverage['AzureMethodQueryUrlEncodingNull'] = 0;
  coverage['AzureXmsRequestClientOverwrite'] = 0;
  coverage['AzureXmsRequestClientOverwriteViaParameter'] = 0;
  coverage['AzureXmsRequestClientIdNull'] = 0;
  coverage['AzureXmsCustomNamedRequestId'] = 0;
  coverage['AzureXmsCustomNamedRequestIdParameterGroup'] = 0;
  coverage['AzureRequestClientIdInError'] = 0;
  coverage['AzureODataFilter'] = 0;

  router.post('/subscriptionId/:location/string/none/path/:scope/:scenario/:subscription', function (req, res, next) {
    var location = req.params.location;
    var scope = req.params.scope;
    var scenario = req.params.scenario;
    var subscription = req.params.subscription;
    var coverageScenario = '';
    if (!req.get("x-ms-client-request-id")) {
       utils.send400(res, next, "Header x-ms-client-request-id must be provided in each request.");
    }
    if (location === 'method') {
       coverageScenario = 'AzureSubscriptionMethod';
       if (scope === 'local') {
           coverageScenario += 'LocalValid';
       } else if (scope === 'global') {
           coverageScenario += 'GlobalValid';
       } else if (scope === 'globalNotProvided') {
           coverageScenario += 'GlobalNotProvidedValid';
       } else  {
           utils.send400(res, next, 'Unable to parse location: "' + util.inspect(location) + '"');
       }
    } else if (location === 'path') {
       coverageScenario = 'AzureSubscriptionPath';
       if (scope === 'local') {
           coverageScenario += 'LocalValid';
       } else if (scope === 'global') {
           coverageScenario += 'GlobalValid';
       } else  {
           utils.send400(res, next, 'Unable to parse location: "' + util.inspect(location) + '"');
       }
    } else if (location === 'swagger') {
       coverageScenario = 'AzureSubscriptionSwagger';
       if (scope === 'local') {
           coverageScenario += 'LocalValid';
       } else if (scope === 'global') {
           coverageScenario += 'GlobalValid';
       } else  {
           utils.send400(res, next, 'Unable to parse location: "' + util.inspect(location) + '"');
       }
    } else {
      utils.send400(res, next, 'Unable to parse definition location: "' + util.inspect(location) + '"');
    }

    if (scenario === subscription) {
        coverage[coverageScenario]++;
        res.send(200).end();
    } else {
           utils.send400(res, next, 'Expected subscription: "' + util.inspect(scenario) + '" did not match actual "' + subscription + '"');
    }

  });

  router.get('/apiVersion/:location/string/none/query/:scope/:scenario', function (req, res, next) {
    var location = req.params.location;
    var scope = req.params.scope;
    var scenario = req.params.scenario;
    var apiVersion = req.query['api-version'];
    var coverageScenario = 'AzureApiVersion';
    if (location === 'method') {
       coverageScenario += 'Method';
       if (scope === 'local' && scenario === '2.0') {
           coverageScenario += 'LocalValid';
       } else if (scope === 'local' && scenario === 'null') {
           coverageScenario += 'LocalNull';
       } else if (scope === 'global') {
           coverageScenario += 'GlobalValid';
       } else if (scope === 'globalNotProvided') {
           coverageScenario += 'GlobalNotProvidedValid';
       } else  {
           utils.send400(res, next, 'Unable to parse location: "' + util.inspect(location) + '"');
       }
    } else if (location === 'path') {
       coverageScenario += 'Path';
       if (scope === 'local') {
           coverageScenario += 'LocalValid';
       } else if (scope === 'global') {
           coverageScenario += 'GlobalValid';
       } else  {
           utils.send400(res, next, 'Unable to parse location: "' + util.inspect(location) + '"');
       }
    } else if (location === 'swagger') {
       coverageScenario += 'Swagger';
       if (scope === 'local') {
           coverageScenario += 'LocalValid';
       } else if (scope === 'global') {
           coverageScenario += 'GlobalValid';
       } else  {
           utils.send400(res, next, 'Unable to parse location: "' + util.inspect(location) + '"');
       }
    } else {
      utils.send400(res, next, 'Unable to parse definition location: "' + util.inspect(location) + '"');
    }

    if (scenario === apiVersion || (scenario === 'null' && Object.keys(req.query).length === 0)) {
        coverage[coverageScenario]++;
        res.send(200).end();
    } else {
           utils.send400(res, next, 'Expected api-version: "' + util.inspect(scenario) + '" did not match actual "' + apiVersion + '"');
    }

  });

  router.get('/skipUrlEncoding/:location/path/valid/path1/path2/path3', function (req, res, next) {
      var location = req.params.location;
      if (location === 'method'  || location === 'path' || location === 'swagger') {
        var scenario = 'Azure' + utils.toPascalCase(location) + 'PathUrlEncoding';
        coverage[scenario]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Unable to determine location "' + util.inspect(location) + '" for AzurePathUrlEncoding scenario');
      }
  });

  router.get('/skipUrlEncoding/:location/query/valid', function (req, res, next) {
      var location = req.params.location;
      if (location === 'method'  || location === 'path' || location === 'swagger') {
        var scenario = 'Azure' + utils.toPascalCase(location) + 'QueryUrlEncoding';
        if (Object.keys(req.query).length > 2 && req.query['q1'] === 'value1' &&
          req.query['q2'] === 'value2' && req.query['q3'] === 'value3') {
          coverage[scenario]++;
          res.status(200).end();
        } else {
          utils.send400(res, next, 'Unexpected query values for scenario "' + scenario + '": "' + util.inspect(req.query) + '"');
        }
      } else {
        utils.send400(res, next, 'Unable to determine location "' + util.inspect(location) + '" for AzurePathUrlEncoding scenario');
      }
  });

  router.get('/skipUrlEncoding/method/query/null', function (req, res, next) {

        var scenario = 'AzureMethodQueryUrlEncodingNull';
        if (Object.keys(req.query).length <= 1 && (req.query['q1'] === undefined || req.query['q1'] === null)) {
          coverage[scenario]++;
          res.status(200).end();
        } else {
          utils.send400(res, next, 'Unexpected query values for scenario "' + scenario + '": "' + util.inspect(req.query) + '"');
        }
  });
  
  router.get('/odata/filter', function (req, res, next) {
        var scenario = 'AzureODataFilter';
        if (req.query['$filter'] !== "id gt 5 and name eq 'foo'") {
          utils.send400(res, next, 'Unexpected $filter value for "' + scenario + '": expect "id gt 5 and name eq \'foo\'" actual "' + req.query['$filter'] + '"');
        }
        if (req.query['$top'] !== "10") {
          utils.send400(res, next, 'Unexpected $top value for "' + scenario + '": expect "10" actual "' + req.query['$top'] + '"');
        }
        if (req.query['$orderby'] !== "id") {
          utils.send400(res, next, 'Unexpected $top value for "' + scenario + '": expect "id" actual "' + req.query['$orderby'] + '"');
        }
        coverage[scenario]++;
        res.status(200).end();        
  });

  router.get('/overwrite/x-ms-client-request-id/method/', function (req, res, next) {
        var headers = {
          'x-ms-request-id': '123'
        };
        if (!req.headers["x-ms-client-request-id"]) {
          coverage['AzureXmsRequestClientIdNull']++;
          res.set(headers).status(200).end();
        } else if (req.headers["x-ms-client-request-id"] !== '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0') {
          coverage['AzureRequestClientIdInError']++;
          res.set(headers).status(400).end();
        } else {
          coverage['AzureXmsRequestClientOverwrite']++;
          res.set(headers).status(200).end();
        }
  });

  router.get('/overwrite/x-ms-client-request-id/via-param/method/', function (req, res, next) {
        var headers = {
          'x-ms-request-id': '123'
        };
        if (req.get("x-ms-client-request-id") !== '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0') {
          utils.send400(res, next, "Header x-ms-client-request-id must be set to 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.");
        } else {
          coverage['AzureXmsRequestClientOverwriteViaParameter']++;
          res.set(headers).status(200).end();
        }
  });
  
  router.post('/customNamedRequestId', function (req, res, next) {
        var headers = {
          'foo-request-id': '123'
        };
        if (req.get("foo-client-request-id") !== '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0') {
          utils.send400(res, next, "Header foo-client-request-id must be set to 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.");
        } else {
          coverage['AzureXmsCustomNamedRequestId']++;
          res.set(headers).status(200).end();
        }
  });
  
  router.post('/customNamedRequestIdParamGrouping', function (req, res, next) {
        var headers = {
          'foo-request-id': '123'
        };
        if (req.get("foo-client-request-id") !== '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0') {
          utils.send400(res, next, "Header foo-client-request-id must be set to 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.");
        } else {
          coverage['AzureXmsCustomNamedRequestIdParameterGroup']++;
          res.set(headers).status(200).end();
        }
  });
}

specials.prototype.router = router;

module.exports = specials;