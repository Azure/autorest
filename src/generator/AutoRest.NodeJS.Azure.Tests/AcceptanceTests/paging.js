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
          should.not.exist(result.nextLink);
          done();
        });
      });

      it('should get multiple pages', function (done) {
          testClient.paging.getMultiplePages({'clientRequestId': 'client-id', 'pagingGetMultiplePagesOptions': null}, function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
                testClient.paging.getMultiplePagesNext(nextLink, {'clientRequestId': 'client-id', 'pagingGetMultiplePagesOptions': null}, function (err, res) {
                should.not.exist(err);
                loop(res.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.nextLink);
          loop(result.nextLink, 1);
        });
      });

      it('should get multiple pages with odata kind nextLink', function (done) {
          testClient.paging.getOdataMultiplePages({ 'clientRequestId': 'client-id', 'pagingGetOdataMultiplePagesOptions': null }, function (error, result) {
              var loop = function (nextLink, count) {
                  if (nextLink !== null && nextLink !== undefined) {
                      testClient.paging.getOdataMultiplePagesNext(nextLink, { 'clientRequestId': 'client-id', 'pagingGetOdataMultiplePagesOptions': null }, function (err, res) {
                          should.not.exist(err);
                          loop(res.odatanextLink, count + 1);
                      });
                  } else {
                      count.should.be.exactly(10);
                      done();
                  }
              };

              should.not.exist(error);
              should.exist(result.odatanextLink);
              loop(result.odatanextLink, 1);
          });
      });

      it('should get multiple pages with offset', function (done) {
          testClient.paging.getMultiplePagesWithOffset({'offset': 100}, {'clientRequestId': 'client-id'}, function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
                testClient.paging.getMultiplePagesWithOffsetNext(nextLink, {'clientRequestId': 'client-id'}, function (err, res) {
                should.not.exist(err);
                result = res;
                loop(res.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              result[0].properties.id.should.be.exactly(110);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.nextLink);
          loop(result.nextLink, 1);
        });
      });

      it('should get multiple pages with retry on first call', function (done) {
        testClient.paging.getMultiplePagesRetryFirst(function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
              testClient.paging.getMultiplePagesRetryFirstNext(nextLink, function (err, res) {
                should.not.exist(err);
                loop(res.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.nextLink);
          loop(result.nextLink, 1);
        });
      });

      it('should get multiple pages with retry on second call', function (done) {
        testClient.paging.getMultiplePagesRetrySecond(function (error, result) {
          var loop = function (nextLink, count) {
            if (nextLink !== null && nextLink !== undefined) {
              testClient.paging.getMultiplePagesRetrySecondNext(nextLink, function (err, res) {
                should.not.exist(err);
                loop(res.nextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.nextLink);
          loop(result.nextLink, 1);
        });
      });

      it('should get multiple pages with fragmented nextLink', function (done) {
        testClient.paging.getMultiplePagesFragmentNextLink('1.6', 'test_user', function (error, result) {
          var loop = function (odatanextLink, count) {
            if (odatanextLink !== null && odatanextLink !== undefined) {
              testClient.paging.nextFragment('1.6', 'test_user', odatanextLink, function (err, res) {
                should.not.exist(err);
                loop(res.odatanextLink, count + 1);
              });
            } else {
              count.should.be.exactly(10);
              done();
            }
          };

          should.not.exist(error);
          should.exist(result.odatanextLink);
          loop(result.odatanextLink, 1);
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
          testClient.paging.getMultiplePagesFailureNext(result.nextLink, function (error, result) {
            should.exist(error);
            error.message.should.containEql('Expected');
            done();
          });
        });
      });

      it('should fail on invalid next link URL in multiple pages', function (done) {
        testClient.paging.getMultiplePagesFailureUri(function (error, result) {
          should.not.exist(error);
          testClient.paging.getMultiplePagesFailureUriNext(result.nextLink, function (error, result) {
            should.exist(error);
            error.message.should.containEql('Invalid URI');
            done();
          });
        });
      });
    });
  });
});
