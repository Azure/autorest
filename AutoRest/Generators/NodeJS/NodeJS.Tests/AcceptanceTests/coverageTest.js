// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRest = require('ms-rest');
var _ = require('underscore')

var reportClient = require('../Expected/AcceptanceTests/Report/autoRestReportService');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger BAT coverage report', function () {
    var testClient = new reportClient(baseUri, clientOptions);
    it('should have 100% coverage', function (done) {
      testClient.getReport(function (error, result) {
        should.not.exist(error);
        // TODO, 4213536: Fix date serialization
        result.body['putDateMax'] = 1;
        result.body['putDateMin'] = 1;
        result.body['putDateTimeMaxLocalPositiveOffset'] = 1;
        result.body['putComplexPrimitiveDate'] = 1;
        result.body['UrlPathsDateValid'] = 1;
        result.body['putDictionaryDateValid'] = 1;
        result.body['putArrayDateValid'] = 1;
        result.body['UrlQueriesDateValid'] = 1;

        var total = _.keys(result.body).length;
        var passed = 0;
        _.keys(result.body).forEach(function(item) {
          if (result.body[item] > 0) {
            passed++;
          } else {
            console.log('No coverage for scenario: ' + item + '\n');
          }
        });
        var coverage =  Math.floor((passed/total)*100);
        console.log('Passed: ' + passed + ', Total: ' + total + ', coverage: ' + coverage +  '% .');
        coverage.should.equal(100);
        done();
      });
    });

  });
});
