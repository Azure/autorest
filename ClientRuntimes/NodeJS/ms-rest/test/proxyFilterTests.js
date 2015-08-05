// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var url = require('url');
var should = require('should');

var ProxyFilter = require('../lib/filters/proxyFilter');

describe('Proxy filter', function () {

  describe('setting the agent', function() {
    it('should work for http over http', function (done) {
      var proxyFilter = ProxyFilter.create(url.parse('http://localhost:8888'));
      proxyFilter({ url: 'http://service.com' },
        function (resource, callback) {
          resource.agent.should.not.equal(null);
          resource.agent.proxyOptions.hostname.should.equal('localhost');
          resource.agent.proxyOptions.port.should.equal('8888');

          resource.strictSSL.should.equal(false);

          callback();
        },
        function () {
          done();
        });
    });

    it('should work for http over https', function (done) {
      var proxyFilter = ProxyFilter.create(url.parse('https://localhost:8888'));
      proxyFilter({ url: 'http://service.com' },
        function (resource, callback) {
          resource.agent.should.not.equal(null);
          resource.agent.proxyOptions.hostname.should.equal('localhost');
          resource.agent.proxyOptions.port.should.equal('8888');

          resource.strictSSL.should.equal(false);

          callback();
        },
        function () {
          done();
        });
    });
  });
});
