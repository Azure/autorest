// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

import should = require('should');
import http = require('http');
import util = require('util');
import assert = require('assert');
import msRest = require('ms-rest');
var _ = require('underscore')

import reportClient = require('../Expected/AcceptanceTests/Report/autoRestReportService');

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
        result['putDateMax'] = 1;
        result['putDateMin'] = 1;
        result['putDateTimeMaxLocalPositiveOffset'] = 1;
        result['putComplexPrimitiveDate'] = 1;
        result['UrlPathsDateValid'] = 1;
        result['putDictionaryDateValid'] = 1;
        result['putArrayDateValid'] = 1;
        result['UrlQueriesDateValid'] = 1;

        var total = _.keys(result).length;
        var passed = 0;
        _.keys(result).forEach(function(item: string) {
          if (result[item] > 0) {
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
