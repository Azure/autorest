// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');
var util = require('util');
var msRest = require('../lib/msRest')
var config = require('./mock-config');

function Operations(client) {
  this.client = client;
}

Operations.prototype.getSwagger = function (options, callback) {
  var client = this.client;
  if(!callback && typeof options === 'function') {
    callback = options;
    options = null;
  }
  if (!callback) {
    throw new Error('callback cannot be null.');
  }

  // Construct URL
  var requestUrl = this.client.baseUri;

  // Create HTTP transport objects
  var httpRequest = new msRest.WebResource();
  httpRequest.method = 'GET';
  httpRequest.headers = {};
  httpRequest.url = requestUrl;
  httpRequest.headers['Content-Type'] = 'application/json; charset=utf-8';
  httpRequest.body = null;
  httpRequest.headers['Content-Length'] = 0;

  return client.pipeline(httpRequest, function (err, response, responseBody) {
    if (err) {
      return callback(err);
    }
    var statusCode = response.statusCode;
    // Create Result
    var result = null;
    if (responseBody === '') responseBody = null;
    if (statusCode === 200) {
      var parsedResponse = null;
      try {
        parsedResponse = JSON.parse(responseBody);
        result = JSON.parse(responseBody);
      } catch (error) {
        var deserializationError = new Error(util.format('Error "%s" occurred in deserializing the responseBody - "%s"', error, responseBody));
        deserializationError.request = httpRequest;
        deserializationError.response = response;
        return callback(deserializationError);
      }
    }
    return callback(null, result, httpRequest, response);
  });
};

function SwaggerService(baseUri, options) {

  if (!options) options = {};

  SwaggerService['super_'].call(this, null, options);
  this.baseUri = baseUri;
  if (!this.baseUri) {
    this.baseUri = 'https://domain.example/pet/1';
  }

  this.operations = new Operations(this);
}

util.inherits(SwaggerService, msRest.ServiceClient);

describe('Making a request', function () {

  describe('request petstore-simple', function() {
    it('should work for https', function (done) {
      var swaggerService = new SwaggerService(null, {requestOptions: {testConfig: config}});
      swaggerService.operations.getSwagger({}, function(err, result, httpRequest, response){
        should(err).not.be.ok;
        result.should.match({
          id:1,
          name:"http://petstore.swagger.io/v2/swagger.json",
          photoUrls:[],
          tags:[],
          status:"available"
        });
        done();
      });
    });
  });
});
