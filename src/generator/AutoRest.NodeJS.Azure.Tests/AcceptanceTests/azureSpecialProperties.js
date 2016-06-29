// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRestAzure = require('ms-rest-azure');

var specialsClient = require('../Expected/AcceptanceTests/AzureSpecials/autoRestAzureSpecialParametersTestClient');
var dummySubscriptionId = '1234-5678-9012-3456';
var dummyToken = 'dummy12321343423';
var credentials = new msRestAzure.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Azure Special Properties', function () {
    var testClient = new specialsClient(credentials, dummySubscriptionId, baseUri, clientOptions);
    it('should use the default api-version when no api-version parameter is present', function (done) {
      testClient.apiVersionDefault.getMethodGlobalValid(function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        testClient.apiVersionDefault.getMethodGlobalNotProvidedValid(function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.apiVersionDefault.getPathGlobalValid(function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.apiVersionDefault.getSwaggerGlobalValid(function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              done();
            });
          });
        });
      });
    });

    it('should use the api-version parameter instead of the default api-version when it is present', function (done) {
      testClient.apiVersionLocal.getMethodLocalNull(null, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        testClient.apiVersionLocal.getMethodLocalValid('2.0', function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.apiVersionLocal.getPathLocalValid('2.0', function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.apiVersionLocal.getSwaggerLocalValid('2.0', function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              done();
            });
          });
        });
      });
    });

    it('should use the subscriptionId from credentials by default', function (done) {
      testClient.subscriptionInCredentials.postMethodGlobalNotProvidedValid(function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        testClient.subscriptionInCredentials.postMethodGlobalValid(function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.subscriptionInCredentials.postPathGlobalValid(function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.subscriptionInCredentials.postSwaggerGlobalValid(function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              done();
            });
          });
        });
      });
    });

    it('should use the subscriptionId parameter when it is present', function (done) {
      testClient.subscriptionInMethod.postMethodLocalNull(null, function (error, result) {
        should.exist(error);
        error.message.should.match(/subscriptionId cannot be null or undefined and it must be of type string./ig);
        testClient.subscriptionInMethod.postMethodLocalValid(dummySubscriptionId, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.subscriptionInMethod.postPathLocalValid(dummySubscriptionId, function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.subscriptionInMethod.postSwaggerLocalValid(dummySubscriptionId, function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              done();
            });
          });
        });
      });
    });

    it('should skip url encoding when specified for path parameters', function (done) {
      var unencodedPath = 'path1/path2/path3';
      testClient.skipUrlEncoding.getMethodPathValid(unencodedPath, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        testClient.skipUrlEncoding.getPathPathValid(unencodedPath, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.skipUrlEncoding.getSwaggerPathValid(unencodedPath, function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            done();
          });
        });
      });
    });

    it('should skip url encoding when specified for query parameters', function (done) {
      var unencodedQuery = 'value1&q2=value2&q3=value3';
      testClient.skipUrlEncoding.getMethodQueryValid(unencodedQuery, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        testClient.skipUrlEncoding.getPathQueryValid(unencodedQuery, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.skipUrlEncoding.getSwaggerQueryValid({ q1: unencodedQuery }, function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.skipUrlEncoding.getMethodQueryNull({ q1: null }, function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              done();
            });
          });
        });
      });
    });

    it('should overwrite x-ms-client-request-id', function (done) {
      var validClientId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0';
      testClient.xMsClientRequestId.paramGet(validClientId, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        response.headers['x-ms-request-id'].should.equal('123');
        var options = {
          customHeaders: {
            'x-ms-client-request-id': validClientId
          }
        };
        testClient.xMsClientRequestId.get(options, function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          response.headers['x-ms-request-id'].should.equal('123');
          done();
        });
      });
    });

    it('should not overwrite x-ms-client-request-id', function (done) {
      var testClient2 = new specialsClient(credentials, dummySubscriptionId, baseUri, clientOptions);
      testClient2.generateClientRequestId = false;
      testClient2.xMsClientRequestId.get(function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        response.headers['x-ms-request-id'].should.equal('123');
        done();
      });
    });

    it('should have x-ms-request-id in the error object', function (done) {
      var invalidClientId = '123';
      var options = {
        customHeaders: {
          'x-ms-client-request-id': invalidClientId
        }
      };
      testClient.xMsClientRequestId.get(options, function (error, result, request, response) {
        should.exist(error);
        error.response.headers['x-ms-request-id'].should.equal('123');
        done();
      });
    });
    
    it('should allow custom-named request-id headers to be used', function (done) {
      testClient.header.customNamedRequestId("9C4D50EE-2D56-4CD3-8152-34347DC9F2B0", function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        should.not.exist(request.headers["x-ms-client-request-id"]);
        should.equal(response.headers["foo-request-id"], "123");
        done();
      });
    });
    
    it('should allow custom-named request-id headers to be used with parameter grouping', function (done) {
      testClient.header.customNamedRequestIdParamGrouping({fooClientRequestId: "9C4D50EE-2D56-4CD3-8152-34347DC9F2B0"}, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        should.not.exist(request.headers["x-ms-client-request-id"]);
        should.equal(response.headers["foo-request-id"], "123");
        done();
      });
    });
    
    it('should support OData filter', function (done) {
      var options = {
        filter: "id gt 5 and name eq 'foo'",
        top: 10,
        orderby: 'id'
      };
      testClient.odata.getWithFilter(options, function (error, result, request, response) {
        should.not.exist(error);
        response.statusCode.should.equal(200);
        done();
      });
    });

  });
});
