// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');

var SubscriptionCredentials = require('../lib/subscriptionCredentials');
var dummySubscriptionId = 'dummySubscriptionId';
var dummyToken = 'dummy12321343423';
var dummyScheme = 'dummyScheme';

describe('UserToken credentials', function () {
  describe('construction', function () {
    
    it('should succeed with subscription id', function () {
      var cred;
      (function () {
        cred = new SubscriptionCredentials(dummyToken, dummySubscriptionId, dummyScheme);
      }).should.not.throw();
      cred.token.should.equal(dummyToken);
      cred.subscriptionId.should.equal(dummySubscriptionId);
      cred.authorizationScheme.should.equal(dummyScheme);
    });
    
    it('should fail without subscription id', function () {
      (function () {
        new SubscriptionCredentials(dummyToken);
      }).should.throw();
    });

    it('should fail without token', function () {
      (function () {
        new SubscriptionCredentials(null, dummySubscriptionId);
      }).should.throw();
    });
  });

  describe('usage', function () {
    it('should set auth header with bearer scheme in request', function (done) {
      var creds = new SubscriptionCredentials(dummyToken, dummySubscriptionId);
      var request = {
        headers: {}
      };
      
      creds.signRequest(request, function () {
        request.headers.should.have.property('authorization');
        request.headers['authorization'].should.match(new RegExp('^Bearer\\s+' + dummyToken + '$'));
        done();
      });
    });    
  });
});