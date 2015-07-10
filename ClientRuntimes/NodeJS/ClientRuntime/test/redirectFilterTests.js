// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var url = require('url');
var should = require('should');

var RedirectFilter = require('../lib/filters/redirectFilter');

describe('Redirect filter', function () {
  it('should redirect a POST request with status code 303 into a GET request ' + 
    'when redirect url is present in location header', function (done) {
    var resource = { method: 'POST', url: 'http://localhost:3000/http/redirect/303' };
    var response1 = {
      statusCode: 303, 
      body: '',
      headers: { location: '/http/success/get/200' }, 
      method: 'POST'
    };
    var redirectFilter = RedirectFilter.create();
    
    var mocknext = function (resource, handleRedirect) {
      if (resource.method !== 'GET') {
        handleRedirect(null, response1, response1.body);
      } else {
        resource.method.should.equal('GET');
        resource.url.should.equal('http://localhost:3000/http/success/get/200');
        done();
      }
    };
    
    redirectFilter(resource, mocknext, null);
  });
  
  it('should not redirect a POST request with status code 303 into a GET request ' + 
    'when redirect url is not present in location header', function (done) {
    var resource = { method: 'POST', url: 'http://localhost:3000/http/redirect/303' };
    var response1 = {
      statusCode: 303, 
      body: '', 
      headers: {}, 
      method: 'POST'
    };
    var redirectFilter = RedirectFilter.create();
    
    var callback = function (err, response, body) {
      should.not.exist(err);
      response.method.should.equal('POST');
      response.body.should.equal('');
      done();
    };
    
    var mocknext = function (resource, handleRedirect) {
      handleRedirect(null, response1, response1.body);
    };
    
    redirectFilter(resource, mocknext, callback);
  });
  
  it('should redirect a HEAD request with status code 307 when redirect url is ' + 
    'present in location header', function (done) {
    var resource = { method: 'HEAD', url: 'http://localhost:3000/http/redirect/307' };
    var response1 = {
      statusCode: 307, 
      body: '', 
      headers: { location: 'http://dummyurl:9000/http/success/head/200' }, 
      method: 'HEAD'
    };
    var redirectFilter = RedirectFilter.create();
    var calledOnce = false;
    var mocknext = function (resource1, handleRedirect) {
      if (!calledOnce) {
        calledOnce = true;
        handleRedirect(null, response1, response1.body);
      } else {
        resource1.method.should.equal('HEAD');
        resource1.url.should.equal('http://dummyurl:9000/http/success/head/200');
        done();
      }
    };
    
    redirectFilter(resource, mocknext, null);
  });
  
  it('should redirect a DELETE request with status code 307 ' + 
    'when redirect url is present in location header', function (done) {
    var resource = { method: 'DELETE', url: 'http://localhost:3000/http/redirect/307' };
    var response1 = {
      statusCode: 307, 
      body: '', 
      headers: { location: '/http/success/delete/200' }, 
      method: 'DELETE'
    };
    var redirectFilter = RedirectFilter.create();
    var calledOnce = false;
    var mocknext = function (resource1, handleRedirect) {
      if (!calledOnce) {
        calledOnce = true;
        handleRedirect(null, response1, response1.body);
      } else {
        resource1.method.should.equal('DELETE');
        resource1.url.should.equal('http://localhost:3000/http/success/delete/200');
        done();
      }
    };
    
    redirectFilter(resource, mocknext, null);
  });
  
  it('should not redirect a request with status code 305', function (done) {
    var resource = { method: 'PUT', url: 'http://localhost:3000/http/redirect/305' };
    var response1 = {
      statusCode: 305, 
      body: '', 
      headers: { location: '/http/success/get/200' }, 
      method: 'PUT'
    };
    var redirectFilter = RedirectFilter.create();
    
    var callback = function (err, response, body) {
      should.not.exist(err);
      response.method.should.equal('PUT');
      response.body.should.equal('');
      done();
    };
    
    var mocknext = function (resource, handleRedirect) {
      handleRedirect(null, response1, response1.body);
    };
    
    redirectFilter(resource, mocknext, callback);
  });
  
  it('should not redirect a GET request with status code 307 ' + 
    'more than 2 times when maximumRetries is set to 2', function (done) {
    var resource = { method: 'GET', url: 'http://localhost:3000/http/redirect/307' };
    var response1 = {
      statusCode: 307, 
      body: 0, 
      headers: { location: '/http/success/get/200' }, 
      method: 'GET'
    };
    var redirectFilter = RedirectFilter.create(2);
    var count = 0;
    var mocknext = function (resource1, handleRedirect) {
      count++;
      handleRedirect(null, response1, response1.body++);
    };
    
    var callback = function (err, response, body) {
      should.not.exist(err);
      response.method.should.equal('GET');
      count.should.equal(3);
      response.body.should.equal(3);
      done();
    };
    
    redirectFilter(resource, mocknext, callback);
  });
});
