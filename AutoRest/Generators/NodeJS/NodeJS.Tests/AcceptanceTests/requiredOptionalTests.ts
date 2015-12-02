// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

import should = require('should');
import http = require('http');
import util = require('util');
import assert = require('assert');
import msRest = require('ms-rest');

import reqOptClient = require('../Expected/AcceptanceTests/RequiredOptional/autoRestRequiredOptionalTestService');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';


describe('nodejs', function () {

  describe('Swagger Required Optional BAT', function () {

    describe('Basic Required Optional Operations', function () {
      var testClient = new reqOptClient('', '', baseUri, clientOptions);

      it('should throw error on null path parameter', function (done) {
        testClient.implicit.getRequiredPath(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('pathParameter cannot be null or undefined and it must be of type string.');
          done();
        });
      });

      it('should accept null values for query parameters', function (done) {
        testClient.implicit.putOptionalQuery({ queryParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should accept null values for optional header parameters', function (done) {
        testClient.implicit.putOptionalHeader({ queryParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should accept null values for optional body parameters', function (done) {
        testClient.implicit.putOptionalBody({ bodyParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required integer parameters', function (done) {
        testClient.explicit.postRequiredIntegerParameter(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('bodyParameter cannot be null or undefined and it must be of type number.');
          done();
        });
      });
      it('should accept null values for optional integer parameters', function (done) {
        testClient.explicit.postOptionalIntegerParameter({ bodyParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required integer properties', function (done) {
        testClient.explicit.postRequiredIntegerProperty(<any>{ 'value': null }, function (error, result) {
          should.exist(error);
          error.message.should.containEql('value');
          error.message.should.containEql('cannot be null or undefined');
          done();
        });
      });
      it('should accept null values for optional integer properties', function (done) {
        testClient.explicit.postOptionalIntegerProperty({ value: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required integer header', function (done) {
        testClient.explicit.postRequiredIntegerHeader(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('headerParameter cannot be null or undefined and it must be of type number.');
          done();
        });
      });
      it('should accept null values for optional integer header', function (done) {
        testClient.explicit.postOptionalIntegerHeader({ headerParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required string parameters', function (done) {
        testClient.explicit.postRequiredStringParameter(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('bodyParameter cannot be null or undefined and it must be of type string.');
          done();
        });
      });
      it('should accept null values for optional string parameters', function (done) {
        testClient.explicit.postOptionalStringParameter({ bodyParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required string properties', function (done) {
        testClient.explicit.postRequiredStringProperty(<any>{ 'value': null }, function (error, result) {
          should.exist(error);
          error.message.should.containEql('value');
          error.message.should.containEql('cannot be null or undefined');
          done();
        });
      });
      it('should accept null values for optional string properties', function (done) {
        testClient.explicit.postOptionalStringProperty({ value: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required string header', function (done) {
        testClient.explicit.postRequiredStringHeader(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('headerParameter cannot be null or undefined and it must be of type string.');
          done();
        });
      });
      it('should accept null values for optional string header', function (done) {
        testClient.explicit.postOptionalStringHeader({ bodyParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required class parameters', function (done) {
        testClient.explicit.postRequiredClassParameter(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('bodyParameter cannot be null or undefined.');
          done();
        });
      });
      it('should accept null values for optional class parameters', function (done) {
        testClient.explicit.postOptionalClassParameter({ bodyParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required class properties', function (done) {
        testClient.explicit.postRequiredClassProperty(<any>{ 'value': null }, function (error, result) {
          should.exist(error);
          error.message.should.containEql('value');
          error.message.should.containEql('cannot be null or undefined');
          done();
        });
      });
      it('should accept null values for optional class properties', function (done) {
        testClient.explicit.postOptionalClassProperty({ value: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required array parameters', function (done) {
        testClient.explicit.postRequiredArrayParameter(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('bodyParameter cannot be null or undefined and it must be of type array.');
          done();
        });
      });
      it('should accept null values for optional array parameters', function (done) {
        testClient.explicit.postOptionalArrayParameter({ bodyParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required array properties', function (done) {
        testClient.explicit.postRequiredArrayProperty(<any>{ 'value': null }, function (error, result) {
          should.exist(error);
          error.message.should.containEql('value');
          error.message.should.containEql('cannot be null or undefined');
          done();
        });
      });
      it('should accept null values for optional array properties', function (done) {
        testClient.explicit.postOptionalArrayProperty({ value: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null values for required array header', function (done) {
        testClient.explicit.postRequiredArrayHeader(null, function (error, result) {
          should.exist(error);
          error.message.should.containEql('headerParameter cannot be null or undefined and it must be of type array.');
          done();
        });
      });
      it('should accept null values for optional array header', function (done) {
        testClient.explicit.postOptionalArrayHeader({ headerParameter: null }, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw error on null global property in path', function (done) {
        testClient.requiredGlobalPath = null;
        testClient.implicit.getRequiredGlobalPath(function (error, result) {
          should.exist(error);
          error.message.should.containEql('this.client.requiredGlobalPath cannot be null or undefined and it must be of type string.');
          done();
        });
      });
      it('should throw error on null global property in query', function (done) {
        testClient.requiredGlobalQuery = null;
        testClient.implicit.getRequiredGlobalQuery(function (error, result) {
          should.exist(error);
          error.message.should.containEql('this.client.requiredGlobalQuery cannot be null or undefined and it must be of type string.');
          done();
        });
      });
      it('should accept null values for optional global property in query', function (done) {
        testClient.implicit.getOptionalGlobalQuery(function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
    });
  });
});