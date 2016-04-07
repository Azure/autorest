// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRestAzure = require('ms-rest-azure');

var customBaseUriClient = require('../Expected/AcceptanceTests/CustomBaseUri/autoRestParameterizedHostTestClient');
var dummySubscriptionId = '1234-5678-9012-3456';
var dummyToken = 'dummy12321343423';
var credentials = new msRestAzure.TokenCredentials(dummyToken);

var clientOptions = {};

describe('nodejs', function () {
  describe('Custom BaseUri Client', function () {
    clientOptions.host = 'host:3000';
    var testClient = new customBaseUriClient(credentials, clientOptions);
    it('should return 200', function (done) {
      testClient.paths.getEmpty('local', function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        done();
      });
    });
    it('should throw due to bad "host", bad "account" and missing account', function (done) {
      testClient.host = 'nonexistent';
      testClient.paths.getEmpty('local', function (error, result, request, response) {
        should.exist(error);
        should.not.exist(result);
        testClient.host = 'host:3000';
        testClient.paths.getEmpty('bad', function (error, result, request, response) {
          should.exist(error);
          should.not.exist(result);
          testClient.paths.getEmpty(null, function (error, result, request, response) {
            should.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });
    });
  });
});