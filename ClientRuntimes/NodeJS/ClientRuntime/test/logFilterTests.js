// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');
var url = require('url');

var LogFilter = require('../lib/filters/logFilter');

describe('Log filter', function () {
  
  it('should log messages when a logger object is provided', function (done) {
    var output = '';
    var callback = function () { done(); };
    var mocknext = function (err, response, body) {
      output.should.containEql('logFilter, request:');
      callback();
    };
    var logFilter = LogFilter.create({log : function (message) { output += message + '\n'; }});
    logFilter({a: 'b', c: '1'}, mocknext, callback);
  });
});
