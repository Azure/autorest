// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRestAzure = require('ms-rest-azure');

var azureCompositeClient = require('../Expected/AcceptanceTests/AzureCompositeModelClient/azureCompositeModel');
var dummyToken = 'dummy12321343423';
var credentials = new msRestAzure.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Azure Composite Client', function () {
    var testClient = new azureCompositeClient(credentials, baseUri, clientOptions);
    it('should get and put valid basic type properties', function (done) {
      testClient.basicOperations.getValid(function (error, result) {
        should.not.exist(error);
        result.id.should.equal(2);
        result.name.should.equal('abc');
        result.color.should.equal('YELLOW');
        testClient.basicOperations.putValid({ 'id': 2, 'name': 'abc', color: 'Magenta' }, function (error, result) {
          should.not.exist(error);
          done();
        });
      });
    });
  });
});
