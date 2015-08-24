// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRest = require('ms-rest');
var msRestAzure = require('ms-rest-azure');

var pagingClient = require('../Expected/AcceptanceTests/Paging/autoRestPagingTestService');

var dummySubscriptionId = 'a878ae02-6106-429z-9397-58091ee45g98';
var dummyToken = 'dummy12321343423';
var credentials = new msRestAzure.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger Pageable BAT', function () {

    describe('Pageable Operations', function () {
      clientOptions.requestOptions = { jar: true };
      clientOptions.filters = [new msRest.ExponentialRetryPolicyFilter(3, 0, 0, 0)];
      clientOptions.noRetryPolicy = true;
      var testClient = new pagingClient(credentials, baseUri, clientOptions);

      it('should get single pages', function (done) {
        testClient.paging.getSinglePages(function (error, result) {
          should.not.exist(error);
          should.not.exist(result.body.nextLink);
          done();
        });
      });

      it('should get multiple pages', function (done) {
        testClient.paging.getMultiplePages(function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
              testClient.paging.getMultiplePagesNext(nextLink, function (err, res) {
                should.not.exist(err);
                loop(res.body.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.body.nextLink);
          loop(result.body.nextLink, 1);
        });
      });

      it('should get multiple pages with retry on first call', function (done) {
        testClient.paging.getMultiplePagesRetryFirst(function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
              testClient.paging.getMultiplePagesRetryFirstNext(nextLink, function (err, res) {
                should.not.exist(err);
                loop(res.body.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.body.nextLink);
          loop(result.body.nextLink, 1);
        });
      });

      it('should get multiple pages with retry on second call', function (done) {
        testClient.paging.getMultiplePagesRetrySecond(function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
              testClient.paging.getMultiplePagesRetrySecondNext(nextLink, function (err, res) {
                should.not.exist(err);
                loop(res.body.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.body.nextLink);
          loop(result.body.nextLink, 1);
        });
      });

      it('should fail on 400 single page', function (done) {
        testClient.paging.getSinglePagesFailure(function (error, result) {
          should.exist(error);
          error.message.should.containEql('Expected');
          done();
        });
      });

      it('should fail on 400 multiple pages', function (done) {
        testClient.paging.getMultiplePagesFailure(function (error, result) {
          should.not.exist(error);
          testClient.paging.getMultiplePagesFailureNext(result.body.nextLink, function (error, result) {
            should.exist(error);
            error.message.should.containEql('Expected');
            done();
          });
        });
      });

      it('should fail on invalid next link URL in multiple pages', function (done) {
        testClient.paging.getMultiplePagesFailureUri(function (error, result) {
          should.not.exist(error);
          testClient.paging.getMultiplePagesFailureUriNext(result.body.nextLink, function (error, result) {
            should.exist(error);
            error.message.should.containEql('Invalid URI');
            done();
          });
        });
      });
    });
  });
});
