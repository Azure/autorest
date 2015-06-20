// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');
var util = require('util');
var dump = util.inspect;

var AzureServiceClient = require('../lib/azureServiceClient');
var msRest = require('ms-rest');
var credentials = new msRest.TokenCredentials({
  authorizationScheme: 'Bearer',
  token: '<your token here>'
});

var clientOptions = {};
describe('AzureServiceClient', function () {
  describe('Constructor intialization', function () {
    it('should intialize with no parameters', function (done) {
      (new AzureServiceClient()).should.not.throw();
      done();
    });

    it('should intialize with credentials only', function (done) {
      (new AzureServiceClient(credentials)).should.not.throw();
      done();
    });

    it('should intialize with credentials and request options', function (done) {
      clientOptions.requestOptions = { jar: true };
      clientOptions.filters = [new msRest.ExponentialRetryPolicyFilter(3, 0.0001, 0.0001, 0.0001)];
      clientOptions.noRetryPolicy = true;
      (new AzureServiceClient(credentials, clientOptions)).should.not.throw();
      done();
    });
  });

  describe('LRO', function () {
    var requestUrl = 'http://dummy';
    var resultOfInitialRequest = {
      response: {
        statusCode : 201,
        headers: {
          'azure-asyncoperation' : requestUrl
        }
      }
    };
    var mockedGetStatus = function (url, callback) {
      console.log('url' + url);
      if (url !== requestUrl) {
        throw new Error('The given url does not match the expected url');
      }
      return callback(null, { body: { status : 200 } });
    };
    it('should get PutOperationResult correctly', function (done) {
      var client = new AzureServiceClient();
      client._getStatus = mockedGetStatus;
      client.longRunningOperationRetryTimeout = 0.001;
      client.getPutOperationResult(resultOfInitialRequest, function () { }, function (err, result) {
        if (err) {
          console.log('err is');
          console.log(err);
        }
        console.log('result is' + result);
        console.log('We are here!!');
        done();
      });
    });
  });
});