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
      var clientOptions = {};
      clientOptions.requestOptions = { jar: true };
      clientOptions.filters = [new msRest.ExponentialRetryPolicyFilter(3, 0.0001, 0.0001, 0.0001)];
      clientOptions.noRetryPolicy = true;
      (new AzureServiceClient(credentials, clientOptions)).should.not.throw();
      done();
    });
  });
  
  describe('Lro', function () {
    
    var testResourceName = 'foo';
    var testError = 'Lro error for you';
    var urlFromAzureAsyncOPHeader_Return200 = 'http://dummyurlFromAzureAsyncOPHeader_Return200';
    var urlFromLocationHeader_Return200 = 'http://dummyurlurlFromLocationHeader_Return200';
    var url_ReturnError = 'http://dummyurl_ReturnError';
    
    var resultOfInitialRequest = {
      response: {
        statusCode : 201,
        headers: {},
      },
      body: {
        properties: {
          provisioningState: 'InProgress'
        }
      }
    };
    
    var mockedGetStatus = function (url, callback) {
      if (url === urlFromAzureAsyncOPHeader_Return200) {
        return callback(null, { body: { status : 'Succeeded' } });
      } if (url === urlFromLocationHeader_Return200) {
        return callback(null, {
          response: { statusCode: 200 },
          body: {
            status : 'Succeeded',
            'name': testResourceName
          }
        });
      } else if (url === url_ReturnError) {
        return callback({ message: testError });
      } else {
        throw new Error('The given url does not match the expected url');
      }
    };
    
    var pollerProvidedByClient = function (callback) {
      var result = {
        body: {
          'properties': { 'provisioningState': 'Succeeded' }, 
          'name': testResourceName
        }
      };
      callback(null, result);
    };
    
    var client = new AzureServiceClient();
    client._getStatus = mockedGetStatus;
    client.longRunningOperationRetryTimeout = 0;
    
    describe('Put', function () {
      it('works by polling from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = urlFromAzureAsyncOPHeader_Return200;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });
      });
      
      it('works by polling from the location header', function (done) {
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });

      });
      
      it('works by invoking customzied poller from the client', function (done) {
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });
      });
      
      it('returns error if failed to poll from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = url_ReturnError;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('returns error if failed to poll from the location header', function (done) {
        resultOfInitialRequest.response.headers['location'] = url_ReturnError;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('returns error on failure from the customzied poller from the client', function (done) {
        var badPoller = function (callback) {
          return callback({ message: testError });
        };
        client.getPutOperationResult(resultOfInitialRequest, badPoller, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
    });

    describe('Post-or-Delete', function () {
      it('works by polling from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = urlFromAzureAsyncOPHeader_Return200;
        client.getPostOrDeleteOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });
      });
      
      it('works by polling from the location header', function (done) {
        client.getPostOrDeleteOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });

      });
          
      it('returns error if failed to poll from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = url_ReturnError;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('returns error if failed to poll from the location header', function (done) {
        resultOfInitialRequest.response.headers['location'] = url_ReturnError;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('PutOperationResult returns error on failure from the customzied poller from the client', function (done) {
        var badPoller = function (callback) {
          return callback({ message: testError });
        };
        client.getPutOperationResult(resultOfInitialRequest, badPoller, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });

    });
  });
});