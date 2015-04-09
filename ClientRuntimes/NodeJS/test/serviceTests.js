// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 
'use strict';

var should = require('should');
var http = require('http');
var util = require('util');

var ps = require('./data/swaggerPetstore');
var clientRuntime = require('../lib/clientRuntime');


describe('nodejs', function () {
  var suite;
  var server;
  var credentials;
  before(function (done) {
    server = http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'application/json'});
      res.end('{"Id": "1", "Name": "Pet Rock", "Tag": "Low Maintenance"}');
    });
    server.listen(1337, '127.0.0.1');
    console.log('Server running at http://127.0.0.1:1337/');
    credentials = new clientRuntime.TokenCredentials({
      subscriptionId: "<your subscription id>",
      token: "<your token here>"
    });
    done();
  });

  after(function (done) {
    console.log("Closing the server");
    server.close(done);
  });

  beforeEach(function (done) {
    done();
  });

  afterEach(function (done) {
    done();
  });

  function createLogFilter() {
    return function handle (resource, next, callback) {
      function logMessage(err, response, body) {
        var result = JSON.parse(response.body);
        result.Id.should.equal("1");
        result.Name.should.equal("Pet Rock");
        result.Tag.should.equal("Low Maintenance");
        if (callback) {
          callback(err, response, body);
        }
      }
      return next(resource, logMessage);
    };
  }

  describe('client', function () {
    it('created with log filter should work', function (done) {
      var petstore = new ps.SwaggerPetstore("http://localhost:1337", credentials).withFilter(createLogFilter());

      petstore.findPetById(1, function (error, result) {
        result.id.should.equal("1");
        result.name.should.equal("Pet Rock");
        result.tag.should.equal("Low Maintenance");
        done();
      });
    });

    it('created without log filter should work', function (done) {
      var petstore = new ps.SwaggerPetstore("http://localhost:1337", credentials);

      petstore.findPetById(1, function (error, result) {
        result.id.should.equal("1");
        result.name.should.equal("Pet Rock");
        result.tag.should.equal("Low Maintenance");
        done();
      });
    });

    it('created without credentials should work', function (done) {
      var petstore = new ps.SwaggerPetstore("http://localhost:1337");

      petstore.findPetById(1, function (error, result) {
        result.id.should.equal("1");
        result.name.should.equal("Pet Rock");
        result.tag.should.equal("Low Maintenance");
        done();
      });
    });
  });
});