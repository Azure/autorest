// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

import should = require('should');
import http = require('http');
import util = require('util');
import assert = require('assert');
import msRest = require('ms-rest');
import moment = require('moment');
var _ = require('underscore');

import headerClient = require('../Expected/AcceptanceTests/Header/autoRestSwaggerBATHeaderService');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger Header BAT', function () {

    describe('Basic Header Operations', function () {
      var testClient = new headerClient(baseUri, clientOptions);
      it('should override existing headers', function (done) {
        testClient.header.paramExistingKey('overwrite', function (error, result, request, response) {
          should.not.exist(error);
          testClient.header.responseExistingKey(function (error, result, request, response) {
            response.headers['user-agent'].should.be.exactly('overwrite');
            done();
          });
        });
      });

      it('should throw on changing protected headers', function(done) {
        testClient.header.paramProtectedKey('text/html', function (error, result, request, response) {
          should.not.exist(error);
          testClient.header.responseProtectedKey(function (error, result, request, response) {
            response.headers['content-type'].should.be.exactly('text/html; charset=utf-8');
            done();
          });
        });
      });

      it('should send and receive integer type headers', function(done) {
        testClient.header.paramInteger('positive', 1, function(error, result) {
          should.not.exist(error);
          testClient.header.paramInteger('negative', -2, function (error, result) {
            should.not.exist(error);
            testClient.header.responseInteger('positive', function (error, result, request, response) {
              should.not.exist(error);
              response.headers['value'].should.be.exactly('1');
              testClient.header.responseInteger('negative', function (error, result, request, response) {
                should.not.exist(error);
                response.headers['value'].should.be.exactly('-2');
                done();
              });
            });
          });
        });
      });

      it('should send and receive long type headers', function(done) {
        testClient.header.paramLong('positive', 105, function(error, result) {
          should.not.exist(error);
          testClient.header.paramLong('negative', -2, function (error, result) {
            should.not.exist(error);
            testClient.header.responseLong('positive', function (error, result, request, response) {
              should.not.exist(error);
              response.headers['value'].should.be.exactly('105');
              testClient.header.responseLong('negative', function (error, result, request, response) {
                should.not.exist(error);
                response.headers['value'].should.be.exactly('-2');
                done();
              });
            });
          });
        });
      });

      it('should send and receive float type headers', function(done) {
        testClient.header.paramFloat('positive', 0.07, function(error, result) {
          should.not.exist(error);
          testClient.header.paramFloat('negative', -3.0, function (error, result) {
            should.not.exist(error);
            testClient.header.responseFloat('positive', function (error, result, request, response) {
              should.not.exist(error);
              response.headers['value'].should.be.exactly('0.07');
              testClient.header.responseFloat('negative', function (error, result, request, response) {
                should.not.exist(error);
                JSON.parse(response.headers['value']).should.be.exactly(-3.0);
                done();
              });
            });
          });
        });
      });

      it('should send and receive double type headers', function(done) {
        testClient.header.paramDouble('positive', 7e120, function(error, result) {
          should.not.exist(error);
          testClient.header.paramDouble('negative', -3.0, function (error, result) {
            should.not.exist(error);
            testClient.header.responseDouble('positive', function (error, result, request, response) {
              should.not.exist(error);
              JSON.parse(response.headers['value']).should.be.exactly(7e120);
              testClient.header.responseDouble('negative', function (error, result, request, response) {
                should.not.exist(error);
                JSON.parse(response.headers['value']).should.be.exactly(-3.0);
                done();
              });
            });
          });
        });
      });

      it('should send and receive boolean type headers', function(done) {
        testClient.header.paramBool('true', true, function(error, result) {
          should.not.exist(error);
          testClient.header.paramBool('false', false, function (error, result) {
            should.not.exist(error);
            testClient.header.responseBool('true', function (error, result, request, response) {
              should.not.exist(error);
              response.headers['value'].should.be.exactly('true');
              testClient.header.responseBool('false', function (error, result, request, response) {
                should.not.exist(error);
                response.headers['value'].should.be.exactly('false');
                done();
              });
            });
          });
        });
      });
      it('should send and receive string type headers', function (done) {
        testClient.header.paramString('valid', <any>{ value: 'The quick brown fox jumps over the lazy dog' }, function (error, result) {
          should.not.exist(error);
          testClient.header.paramString('null', { value: null }, function (error, result) {
            should.not.exist(error);
            testClient.header.paramString('empty', { value: '' }, function (error, result) {
              should.not.exist(error);
              testClient.header.responseString('valid', function (error, result, request, response) {
                should.not.exist(error);
                response.headers['value'].should.be.exactly('The quick brown fox jumps over the lazy dog');
                testClient.header.responseString('null', function (error, result, request, response) {
                  should.not.exist(error);
                  should.not.exist(JSON.parse(response.headers['value']));
                  testClient.header.responseString('empty', function (error, result, request, response) {
                    should.not.exist(error);
                    response.headers['value'].should.be.exactly('');
                    done();
                  });
                });
              });
            });
          });
        });
      });
      it('should send and receive enum type headers', function (done) {
        testClient.header.paramEnum('valid', { value: 'GREY' }, function (error, result) {
          should.not.exist(error);
          testClient.header.paramEnum('null', { value: null }, function (error, result) {
            should.not.exist(error);
            testClient.header.responseEnum('valid', function (error, result, request, response) {
              should.not.exist(error);
              response.headers['value'].should.be.exactly('GREY');
              testClient.header.responseEnum('null', function (error, result, request, response) {
                should.not.exist(error);
                response.headers['value'].should.be.exactly('');
                done();
              });
            });
          });
        });
      });
      it('should send and receive date type headers', function (done) {
        testClient.header.paramDate('valid', new Date('2010-01-01'), function (error, result) {
          should.not.exist(error);
          testClient.header.paramDate('min', new Date('0001-01-01'), function (error, result) {
            should.not.exist(error);
            testClient.header.responseDate('valid', function (error, result, request, response) {
              should.not.exist(error);
              _.isEqual(new Date(response.headers['value']), new Date('2010-01-01')).should.be.exactly(true);
              testClient.header.responseDate('min', function (error, result, request, response) {
                should.not.exist(error);
                _.isEqual(new Date(response.headers['value']), new Date('0001-01-01')).should.be.exactly(true);
                done();
              });
            });
          });
        });
      });
      it('should send and receive datetime type headers', function (done) {
        testClient.header.paramDatetime('valid', new Date('2010-01-01T12:34:56Z'), function (error, result) {
          should.not.exist(error);
          testClient.header.paramDatetime('min', new Date('0001-01-01T00:00:00Z'), function (error, result) {
            should.not.exist(error);
            testClient.header.responseDatetime('valid', function (error, result, request, response) {
              should.not.exist(error);
              _.isEqual(new Date(response.headers['value']), new Date('2010-01-01T12:34:56Z')).should.be.exactly(true);
              testClient.header.responseDatetime('min', function (error, result, request, response) {
                should.not.exist(error);
                _.isEqual(new Date(response.headers['value']), new Date('0001-01-01T00:00:00Z')).should.be.exactly(true);
                done();
              });
            });
          });
        });
      });
      it('should send and receive datetimerfc1123 type headers', function (done) {
        testClient.header.paramDatetimeRfc1123('valid', <any>{ value: new Date('2010-01-01T12:34:56Z') }, function (error, result) {
          should.not.exist(error);
          testClient.header.paramDatetimeRfc1123('min', { value: new Date('0001-01-01T00:00:00Z') }, function (error, result) {
            should.not.exist(error);
            testClient.header.responseDatetimeRfc1123('valid', function (error, result, request, response) {
              should.not.exist(error);
              _.isEqual(new Date(response.headers['value']), new Date('Fri, 01 Jan 2010 12:34:56 GMT')).should.be.exactly(true);
              testClient.header.responseDatetimeRfc1123('min', function (error, result, request, response) {
                should.not.exist(error);
                _.isEqual(new Date(response.headers['value']), new Date('Mon, 01 Jan 0001 00:00:00 GMT')).should.be.exactly(true);
                done();
              });
            });
          });
        });
      });
      it('should send and receive duration type headers', function (done) {
        var duration = moment.duration({ days: 123, hours: 22, minutes: 14, seconds: 12, milliseconds: 11 });
        testClient.header.paramDuration('valid', duration, function (error, result) {
          should.not.exist(error);
          testClient.header.responseDuration('valid', function (error, result, request, response) {
            should.not.exist(error);
            _.isEqual(response.headers['value'], 'P123DT22H14M12.011S').should.be.exactly(true);
            done();
          });
        });
      });
      it('should send and receive byte array type headers', function (done) {
        var bytes = new Buffer('啊齄丂狛狜隣郎隣兀﨩');
        testClient.header.paramByte('valid', bytes, function (error, result) {
          should.not.exist(error);
          testClient.header.responseByte('valid', function (error, result, request, response) {
            should.not.exist(error);
            response.headers['value'].should.be.exactly(bytes.toString('base64'));
            done();
          });
        });
      });
    });
  });
});