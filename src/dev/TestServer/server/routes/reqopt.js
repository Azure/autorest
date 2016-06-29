var express = require('express');
var router = express.Router();
var util = require('util');
var utils = require('../util/utils')

//Convert to pascal case
var pascalCase = function (input) {

}
var reqopt = function (coverage) {
  coverage['OptionalImplicitQuery'] = 0;
  coverage['OptionalImplicitHeader'] = 0;
  coverage['OptionalImplicitBody'] = 0;
  coverage['OptionalIntegerParameter'] = 0;
  coverage['OptionalIntegerProperty'] = 0;
  coverage['OptionalIntegerHeader'] = 0;
  coverage['OptionalStringParameter'] = 0;
  coverage['OptionalStringProperty'] = 0;
  coverage['OptionalStringHeader'] = 0;
  coverage['OptionalClassParameter'] = 0;
  coverage['OptionalClassProperty'] = 0;
  coverage['OptionalArrayParameter'] = 0;
  coverage['OptionalArrayProperty'] = 0;
  coverage['OptionalArrayHeader'] = 0;
  coverage['OptionalGlobalQuery'] = 0;
  
  router.get('/implicit/required/path/:pathParameter', function (req, res, next) {
    utils.send400(res, next, 'Client library failed to throw when an implicitly required path parameter is not provided.');
  });
  
  router.put('/implicit/optional/:scenario', function (req, res, next) {
    if (req.params.scenario === 'query') {
      if (!req.query.queryParameter) {
        coverage['OptionalImplicitQuery']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Please send a null to optional query.');
      }
    } else if (req.params.scenario === 'header') {
      if (!req.get('headerParameter')) {
        coverage['OptionalImplicitHeader']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Please send a null to optional header.');
      }
    } else if (req.params.scenario === 'body') {
      if (req.body === undefined || (req.body && Object.keys(req.body).length === 0 && req.headers['content-length'] === '0')) {
        coverage['OptionalImplicitBody']++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Please send a null to optional body.');
      }
    } else {
      utils.send400(res, next, 'Must specify either it\'s "required" or "optional", "' + req.params.required + '" provided.');
    }
  });
  
  router.put('/required/:type/:scenario', function (req, res, next) {
    utils.send400(res, next, 'Client library failed to throw when a required value type is not provided.');
  });
  
  router.post('/optional/:type/:scenario', function (req, res, next) {
    var covered = "Optional" + utils.toPascalCase(req.params.type) + utils.toPascalCase(req.params.scenario);
    console.log('scenario: ' + covered + '\n');
    if (req.params.scenario === 'parameter') {
      if (req.body === undefined || (req.body && Object.keys(req.body).length === 0 && req.headers['content-length'] === '0')) {
        coverage[covered]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Please send a null to optional ' + req.params.type + ' body.');
      }
    } else if (req.params.scenario === 'property') {
      if (req.body === undefined || (req.body && !req.body['value'])) {
        coverage[covered]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Please send an ' + req.params.type + ' wrapper with ' + req.params.type + ' value \'null\'');
      }
    } else if (req.params.scenario === 'header') {
      if (!req.get('headerParameter')) {
        coverage[covered]++;
        res.status(200).end();
      } else {
        utils.send400(res, next, 'Please send a null to optional ' + req.params.type + ' header.');
      }
    } else if (req.params.scenario === 'response') {
      coverage[covered]++;
      res.status(200).end('null');
    } else if (req.params.scenario === 'responseProperty') {
      coverage[covered]++;
      res.status(200).end('{"value": null }');
    } else if (req.params.scenario === 'responseHeader') {
      coverage[covered]++;
      res.status(200).set('value', null).end();
    }
  });
  
  router.get('/global/required/path/:required_global_path', function (req, res, next) {
    utils.send400(res, next, 'Client library failed to throw when an implicitly required path parameter is not provided.');
  });
  
  router.get('/global/required/query', function (req, res, next) {
    utils.send400(res, next, 'Client library failed to throw when an explicitly required query parameter is not provided.');
  });
  
  router.get('/global/optional/query', function (req, res, next) {
    if (!req.query.optional_global_query) {
      coverage["OptionalGlobalQuery"]++;
      res.status(200).end();
    } else {
      utils.send400(res, next, 'Please send a null to optional query parameter');
    }
  });
};

reqopt.prototype.router = router;

module.exports = reqopt;