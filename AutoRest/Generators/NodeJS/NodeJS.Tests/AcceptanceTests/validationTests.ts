// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

import should = require('should');

import http = require('http');
import util = require('util');
import assert = require('assert');
import msRest = require('ms-rest');
import fs = require('fs');

import stream = require('stream');

import validationClient = require('../Expected/AcceptanceTests/Validation/autoRestValidationTest');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);
var clientOptions: msRest.ServiceClientOptions = {};
var baseUri = 'http://localhost:3000';
describe('nodejs', function () {
  describe('Swagger BAT Validation', function () {
    var testClient = new validationClient(baseUri, clientOptions);
    testClient.subsciptionId = "abc123";
    testClient.apiVersion = "12-34-5678";
    describe('Of Method Parameters', function () {
      it('should test the minimum length constraint on resourceGroupName', function (done) {
        testClient.validationOfMethodParameters("1", 100, function (err, result) {
          should.exist(err);
          err.should.match(/.*resourceGroupName.*constraint.*MinLength.*3/ig);
          done();
        });
      });

      it('should test the maximum length constraint on resourceGroupName', function (done) {
        testClient.validationOfMethodParameters("1234567890A", 100, function (err, result) {
          should.exist(err);
          err.message.should.match(/.*resourceGroupName.*constraint.*MaxLength.*10/ig);
          done();
        });
      });

      it('should test the pattern length constraint on resourceGroupName', function (done) {
        testClient.validationOfMethodParameters("!@#$", 100, function (err, result) {
          should.exist(err);
          err.message.should.match(/.*resourceGroupName.*constraint.*Pattern.*/ig);
          done();
        });
      });

      it('should test the multipleof constraint on id', function (done) {
        testClient.validationOfMethodParameters("123", 105, function (err, result) {
          should.exist(err);
          err.message.should.match(/.*id.*constraint.*MultipleOf.*10/ig);
          done();
        });
      });

      it('should test the InclusiveMinimum constraint on id', function (done) {
        testClient.validationOfMethodParameters("123", 0, function (err, result) {
          should.exist(err);
          err.message.should.match(/.*id.*constraint.*InclusiveMinimum.*100/ig);
          done();
        });
      });

      it('should test the InclusiveMaximum constraint on id', function (done) {
        testClient.validationOfMethodParameters("123", 2000, function (err, result) {
          should.exist(err);
          err.message.should.match(/.*id.*constraint.*InclusiveMaximum.*1000/ig);
          done();
        });
      });
    });

    describe('Of Body Parameters', function () {
      it('should test the ExclusiveMinimum constraint on id', function (done) {
        testClient.validationOfBody("123", 150, { body: {capacity : 0}}, function (err, result) {
          should.exist(err);
          err.message.should.match(/.*capacity.*constraint.*ExclusiveMinimum.*0.*/ig);
          done();
        });
      });
    });
  });
});