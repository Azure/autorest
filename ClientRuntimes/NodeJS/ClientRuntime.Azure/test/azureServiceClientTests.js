// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');
var util = require('util');
var dump = util.inspect;

var AzureServiceClient = require('../lib/azureServiceClient');
var LroStates = require('../lib/constants').LongRunningOperationStates;
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
        headers: {},
      },
      body: {
        properties: {
          provisioningState: LroStates.InProgress
        }
      }
    };
    
    var mockedGetStatus = function (url, callback) {
      if (url === urlFromAzureAsyncOPHeader_Return200) {
        return callback(null, {
          response: { randomFieldFromPollAsyncOpHeader: ''},
          body: { status: 'Succeeded' }
        });
      } if (url === urlFromLocationHeader_Return200) {
        return callback(null, {
          response: {
            statusCode: 200,
            randomFieldFromPollLocationHeader: ''
          },
          body: {
            status : LroStates.Succeeded,
            'name': testResourceName
          }
        });
      } else if (url === url_ReturnError) {
        return callback({ message: testError });
      } else {
        throw new Error('The given url does not match the expected url');
      }
    };
    
    var client = new AzureServiceClient(null, { longRunningOperationRetryTimeoutInSeconds : 0});
    client._getStatus = mockedGetStatus;
    
    describe('Put', function () {
      resultOfInitialRequest.response.statusCode = 201;
      var pollerProvidedByClient = function (callback) {
        var result = {
          body: {
            'properties': { 'provisioningState': LroStates.Succeeded }, 
            'name': testResourceName
          }
        };
        callback(null, result);
      };
      
      it('throw on not Lro related status code', function (done) {
        client.getPutOperationResult({ response: {statusCode: 10000} }, function () { }, function (err, result) {
          err.message.should.containEql('Unexpected polling status code from long running operation');
          done();
        });
      });

      it('works by polling from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = urlFromAzureAsyncOPHeader_Return200;
        resultOfInitialRequest.response.headers['location'] = '';
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });
      });
      
      it('works by polling from the location header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = '';
        resultOfInitialRequest.response.headers['location'] = urlFromLocationHeader_Return200;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          should.exist(result.response.randomFieldFromPollLocationHeader);
          done();
        });
      });
      
      it('works by invoking customized poller from the client', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = '';
        resultOfInitialRequest.response.headers['location'] = '';
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          should.not.exist(err);
          result.body.name.should.equal(testResourceName);
          done();
        });
      });
      
      it('returns error if failed to poll from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = url_ReturnError;
        resultOfInitialRequest.response.headers['location'] = '';
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('returns error if failed to poll from the location header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = '';
        resultOfInitialRequest.response.headers['location'] = url_ReturnError;
        client.getPutOperationResult(resultOfInitialRequest, pollerProvidedByClient, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('returns error on failure from the customized poller from the client', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = '';
        resultOfInitialRequest.response.headers['location'] = '';
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
      resultOfInitialRequest.response.statusCode = 202;
      
      it('throw on not Lro related status code', function (done) {
        client.getPostOrDeleteOperationResult({ response: { statusCode: 201 } }, function (err, result) {
          err.message.should.containEql('Unexpected polling status code from long running operation');
          done();
        });
      });

      it('works by polling from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = urlFromAzureAsyncOPHeader_Return200;
        resultOfInitialRequest.response.headers['location'] = '';
        client.getPostOrDeleteOperationResult(resultOfInitialRequest, function (err, result) {
          should.not.exist(err);
          should.exist(result.response.randomFieldFromPollAsyncOpHeader);
          done();
        });
      });
      
      it('works by polling from the location header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = '';
        resultOfInitialRequest.response.headers['location'] = urlFromLocationHeader_Return200;
        client.getPostOrDeleteOperationResult(resultOfInitialRequest, function (err, result) {
          should.not.exist(err);
          should.exist(result.response.randomFieldFromPollLocationHeader);
          result.body.name.should.equal(testResourceName);
          done();
        });
      });
      
      it('returns error if failed to poll from the azure-asyncoperation header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = url_ReturnError;
        resultOfInitialRequest.response.headers['location'] = '';
        client.getPostOrDeleteOperationResult(resultOfInitialRequest, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
      
      it('returns error if failed to poll from the location header', function (done) {
        resultOfInitialRequest.response.headers['azure-asyncoperation'] = '';
        resultOfInitialRequest.response.headers['location'] = url_ReturnError;
        client.getPostOrDeleteOperationResult(resultOfInitialRequest, function (err, result) {
          err.message.should.containEql(testError);
          done();
        });
      });
    });
  });
});