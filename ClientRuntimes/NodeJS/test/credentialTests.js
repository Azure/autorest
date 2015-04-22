//
// Copyright (c) Microsoft and contributors.  All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//

var should = require('should');

var clientRuntime = require('../lib/clientRuntime');
var TokenCredentials = clientRuntime.TokenCredentials;
var BasicAuthenticationCredentials = clientRuntime.BasicAuthenticationCredentials;
var dummyToken = 'A-dummy-access-token';
var fakeScheme = 'fake-auth-scheme';
var dummyuserName = 'dummy@mummy.com';
var dummyPassword = 'IL0veDummies';

describe('Token credentials', function () {
  describe('usage', function () {
    it('should set auth header with bearer scheme in request', function (done) {
      var creds = new TokenCredentials({token: dummyToken});
      var request = {
        headers: {}
      };

      creds.signRequest(request, function () {
        request.headers.should.have.property('authorization');
        request.headers['authorization'].should.match(new RegExp('^Bearer\\s+' + dummyToken + '$'));
        done();
      });
    });

    it('should set auth header with custom scheme in request', function (done) {
      var creds = new TokenCredentials({token: dummyToken, authorizationScheme: fakeScheme});
      var request = {
        headers: {}
      };

      creds.signRequest(request, function () {
        request.headers.should.have.property('authorization');
        request.headers['authorization'].should.match(new RegExp('^' + fakeScheme + '\\s+' + dummyToken + '$'));
        done();
      });
    });
  });

  describe('construction', function () {

    it('should succeed with token', function () {
      (function () {
        new TokenCredentials({token: dummyToken});
      }).should.not.throw();
    });

    it('should fail without credentials', function () {
      (function () {
        new TokenCredentials();
      }).should.throw();
    });

    it('should fail without token', function () {
      (function () {
        new TokenCredentials({authorizationScheme: fakeScheme});
      }).should.throw();
    });
  });
});

describe('Basic Authentication credentials', function () {
  var encodedCredentials = new Buffer(dummyuserName + ':' + dummyPassword).toString('base64')
  describe('usage', function () {
    it('should base64 encode the username and password and set auth header with baisc scheme in request', function (done) {
      var creds = new BasicAuthenticationCredentials({userName: dummyuserName, password: dummyPassword});
      var request = {
        headers: {}
      };

      creds.signRequest(request, function () {
        request.headers.should.have.property('authorization');
        request.headers['authorization'].should.match(new RegExp('^Basic\\s+' + encodedCredentials + '$'));
        done();
      });
    });

    it('should base64 encode the username and password and set auth header with custom scheme in request', function (done) {
      var creds = new BasicAuthenticationCredentials({userName: dummyuserName, password: dummyPassword, authorizationScheme: fakeScheme});
      var request = {
        headers: {}
      };

      creds.signRequest(request, function () {
        request.headers.should.have.property('authorization');
        request.headers['authorization'].should.match(new RegExp('^' + fakeScheme + '\\s+' + encodedCredentials + '$'));
        done();
      });
    });
  });

  describe('construction', function () {

    it('should succeed with userName and password', function () {
      (function () {
        new BasicAuthenticationCredentials({userName: dummyuserName, password: dummyPassword});
      }).should.not.throw();
    });

    it('should fail without credentials', function () {
      (function () {
        new BasicAuthenticationCredentials();
      }).should.throw();
    });

    it('should fail without userName and password', function () {
      (function () {
        new BasicAuthenticationCredentials({authorizationScheme: fakeScheme});
      }).should.throw();
    });
  });
});