// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');

var numberClient = require('./Generated/NodeJS/autoRestNumberTestService');

describe('AutoRest NuGet Package Node JS code generator smoke test', function () {
  it('should work by using a autoRestNumberTestService', function (done) {
   var testClient = new numberClient('http://localhost:3000', {});
   testClient.number.getBigFloat(function (error, result) {
      should.not.exist(error);
      result.should.equal(3.402823e+20);
      done();
    });
  });
});
