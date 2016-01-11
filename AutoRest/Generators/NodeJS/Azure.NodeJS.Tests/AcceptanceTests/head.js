// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRest = require('ms-rest');
var msRestAzure = require('ms-rest-azure');

var headClient = require('../Expected/AcceptanceTests/Head/autoRestHeadTestService');
var headExceptionClient = require('../Expected/AcceptanceTests/HeadExceptions/autoRestHeadExceptionTestService');

var dummySubscriptionId = 'a878ae02-6106-429z-9397-58091ee45g98';
var dummyToken = 'dummy12321343423';
var credentials = new msRestAzure.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger Head BAT', function () {

    describe('Head Operations', function () {
      var testOptions = clientOptions;
      testOptions.requestOptions = { jar: true };
      testOptions.filters = [new msRest.ExponentialRetryPolicyFilter(3, 0, 0, 0)];
      testOptions.noRetryPolicy = true;
      var testClient = new headClient(credentials, baseUri, clientOptions);

      it('should return true for 200 status code', function (done) {
        testClient.httpSuccess.head200(function (error, result) {
          should.not.exist(error);
          result.should.be.exactly(true);
          done();
        });
      });

      it('should return true for 204 status code', function (done) {
        testClient.httpSuccess.head204(function (error, result) {
          should.not.exist(error);
          result.should.be.exactly(true);
          done();
        });
      });

      it('should return false for 404 status code', function (done) {
        testClient.httpSuccess.head404(function (error, result) {
          should.not.exist(error);
          result.should.be.exactly(false);
          done();
        });
      });
    });

    describe('Head Exception Operations', function () {
      var testOptions = clientOptions;
      testOptions.requestOptions = { jar: true };
      testOptions.filters = [new msRest.ExponentialRetryPolicyFilter(3, 0, 0, 0)];
      testOptions.noRetryPolicy = true;
      var testClient = new headExceptionClient(credentials, baseUri, clientOptions);

      it('should return true for 200 status code', function (done) {
        testClient.headException.head200(function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should return true for 204 status code', function (done) {
        testClient.headException.head204(function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should return false for 404 status code', function (done) {
        testClient.headException.head404(function (error, result) {
          should.exist(error);
          done();
        });
      });
    });
  });
});
