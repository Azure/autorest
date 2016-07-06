// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRestAzure = require('ms-rest-azure');

var parametersTestClient = require('../Expected/AcceptanceTests/AzureParameterGrouping/autoRestParameterGroupingTestService');
var dummyToken = 'dummy12321343423';
var credentials = new msRestAzure.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {
  var body = 1234;
  var header = "header";
  var query = 21;
  var path = "path";

  describe('Azure Parameter Grouping', function () {
    var testClient = new parametersTestClient(credentials, baseUri, clientOptions);
    it('should accept valid required parameters', function (done) {
      testClient.parameterGrouping.postRequired({body: body, customHeader: header, query: query, path: path}, 
          function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        done();
      });
    });

    it('should accept required parameters but null optional parameters', function (done) {
      testClient.parameterGrouping.postRequired({body: body, path: path}, 
          function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        done();
      });
    });

    it('should reject required parameters with missing required property', function (done) {
      testClient.parameterGrouping.postRequired({path: path}, 
          function (error, result, request, response) {
        should.exist(error);
        error.message.should.match(/.*cannot be null or undefined.*/);
        should.not.exist(result);
        should.not.exist(response);
        done();
      });
    });

    it('should reject null required parameters', function (done) {
      testClient.parameterGrouping.postRequired(null, function (error, result, request, response) {
        should.exist(error);
        error.message.should.match(/.*cannot be null or undefined.*/);
        should.not.exist(result);
        should.not.exist(response);
        done();
      });
    });

    it('should accept valid optional parameters', function (done) {
      testClient.parameterGrouping.postOptional({customHeader: header, query: query}, 
          function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        done();
      });
    });

    it('should accept null optional parameters', function (done) {
      var options = { parameterGroupingPostOptionalParameters : null };
      testClient.parameterGrouping.postOptional(options, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        done();
      });
    });

    it('should allow multiple parameter groups', function (done) {
      var options = {
        firstParameterGroup : { headerOne: header, queryOne: query },
        parameterGroupingPostMultiParamGroupsSecondParamGroup: { headerTwo: "header2", queryTwo: 42 }
      };
      testClient.parameterGrouping.postMultiParamGroups(options, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
      });
    });

    it('should allow multiple parameter groups with some defaults omitted', function (done) {
      var options = {
        firstParameterGroup : { headerOne: header},
        parameterGroupingPostMultiParamGroupsSecondParamGroup: { queryTwo: 42 }
      };
      testClient.parameterGrouping.postMultiParamGroups(options, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
      });
    });

    it('should allow parameter group objects to be shared between operations', function (done) {
      var options = {
        firstParameterGroup : { headerOne: header, queryOne: 42 }
      };
      testClient.parameterGrouping.postSharedParameterGroupObject(options, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
      });
    });

  });
});
