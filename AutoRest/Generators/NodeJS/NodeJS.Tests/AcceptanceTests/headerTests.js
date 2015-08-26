// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRest = require('ms-rest');
var _ = require('underscore')

var headerClient = require('../Expected/AcceptanceTests/Header/autoRestSwaggerBATHeaderService');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger Header BAT', function () {

    describe('Basic Header Operations', function () {
      var testClient = new headerClient(baseUri, clientOptions);
      it('should override existing headers', function (done) {
        testClient.header.paramExistingKey('overwrite', function (error, result) {
          should.not.exist(error);
          testClient.header.responseExistingKey(function (error, result) {
            result.response.headers['user-agent'].should.be.exactly('overwrite');
            done();
          });
        });
      });

      it('should throw on changing protected headers', function(done) {
        testClient.header.paramProtectedKey('text/html', function (error, result) {
          should.not.exist(error);
          testClient.header.responseProtectedKey(function (error, result) {
           result.response.headers['content-type'].should.be.exactly('text/html; charset=utf-8');
           done();
          });
        });
      });

      it('should send and receive integer type headers', function(done) {
        testClient.header.paramInteger('positive', 1, function(error, result) {
          should.not.exist(error);
          testClient.header.paramInteger('negative', -2, function(error, result) {
            should.not.exist(error);
            testClient.header.responseInteger('positive', function(error, result) {
              should.not.exist(error);
              result.response.headers['value'].should.be.exactly('1');
              testClient.header.responseInteger('negative', function(error, result) {
                should.not.exist(error);
                result.response.headers['value'].should.be.exactly('-2');
                done();
              });
            });
          });
        });
      });

      it('should send and receive long type headers', function(done) {
        testClient.header.paramLong('positive', 105, function(error, result) {
          should.not.exist(error);
          testClient.header.paramLong('negative', -2, function(error, result) {
            should.not.exist(error);
            testClient.header.responseLong('positive', function(error, result) {
              should.not.exist(error);
              result.response.headers['value'].should.be.exactly('105');
              testClient.header.responseLong('negative', function(error, result) {
                should.not.exist(error);
                result.response.headers['value'].should.be.exactly('-2');
                done();
              });
            });
          });
        });
      });

      it('should send and receive float type headers', function(done) {
        testClient.header.paramFloat('positive', 0.07, function(error, result) {
          should.not.exist(error);
          testClient.header.paramFloat('negative', -3.0, function(error, result) {
            should.not.exist(error);
            testClient.header.responseFloat('positive', function(error, result) {
              should.not.exist(error);
              result.response.headers['value'].should.be.exactly('0.07');
              testClient.header.responseFloat('negative', function(error, result) {
                should.not.exist(error);
                JSON.parse(result.response.headers['value']).should.be.exactly(-3.0);
                done();
              });
            });
          });
        });
      });

      it('should send and receive double type headers', function(done) {
        testClient.header.paramDouble('positive', 7e120, function(error, result) {
          should.not.exist(error);
          testClient.header.paramDouble('negative', -3.0, function(error, result) {
            should.not.exist(error);
            testClient.header.responseDouble('positive', function(error, result) {
              should.not.exist(error);
              JSON.parse(result.response.headers['value']).should.be.exactly(7e120);
              testClient.header.responseDouble('negative', function(error, result) {
                should.not.exist(error);
                JSON.parse(result.response.headers['value']).should.be.exactly(-3.0);
                done();
              });
            });
          });
        });
      });

      it('should send and receive boolean type headers', function(done) {
        testClient.header.paramBool('true', true, function(error, result) {
          should.not.exist(error);
          testClient.header.paramBool('false', false, function(error, result) {
            should.not.exist(error);
            testClient.header.responseBool('true', function(error, result) {
              should.not.exist(error);
              result.response.headers['value'].should.be.exactly('true');
              testClient.header.responseBool('false', function(error, result) {
                should.not.exist(error);
                result.response.headers['value'].should.be.exactly('false');
                done();
              });
            });
          });
        });
      });

      it('should send and receive string type headers', function(done) {
        testClient.header.paramString('valid', 'The quick brown fox jumps over the lazy dog', function(error, result) {
          should.not.exist(error);
          testClient.header.paramString('null', null, function(error, result) {
            should.not.exist(error);
            testClient.header.paramString('empty', '', function(error, result) {
            should.not.exist(error);
              testClient.header.responseString('valid', function(error, result) {
                should.not.exist(error);
                result.response.headers['value'].should.be.exactly('The quick brown fox jumps over the lazy dog');
                testClient.header.responseString('null', function(error, result) {
                  should.not.exist(error);
                  should.not.exist(JSON.parse(result.response.headers['value']));
                  testClient.header.responseString('empty', function(error, result) {
                    should.not.exist(error);
                    result.response.headers['value'].should.be.exactly('');
                    done();
                  });
                });
              });
            });
          });
        });
      });

      it('should send and receive enum type headers', function(done) {
        testClient.header.paramEnum('valid', 'GREY', function(error, result) {
          should.not.exist(error);
          testClient.header.paramEnum('null', null, function(error, result) {
            should.not.exist(error);
            testClient.header.responseEnum('valid', function(error, result) {
              should.not.exist(error);
              result.response.headers['value'].should.be.exactly('GREY');
              testClient.header.responseEnum('null', function(error, result) {
                should.not.exist(error);
                should.not.exist(JSON.parse(result.response.headers['value']));
                done();
              });
            });
          });
        });
      });

      it('should send and receive date type headers', function(done) {
        testClient.header.paramDate('valid', new Date('2010-01-01'), function(error, result) {
          should.not.exist(error);
          testClient.header.paramDate('min', new Date('0001-01-01'), function(error, result) {
            should.not.exist(error);
            testClient.header.responseDate('valid', function(error, result) {
              should.not.exist(error);
              _.isEqual(new Date(result.response.headers['value']), new Date('2010-01-01')).should.be.exactly(true);
              testClient.header.responseDate('min', function(error, result) {
                should.not.exist(error);
                _.isEqual(new Date(result.response.headers['value']), new Date('0001-01-01')).should.be.exactly(true);
                done();
              });
            });
          });
        });
      });

      it('should send and receive datetime type headers', function(done) {
        testClient.header.paramDatetime('valid', new Date('2010-01-01T12:34:56Z'), function(error, result) {
          should.not.exist(error);
          testClient.header.paramDatetime('min', new Date('0001-01-01T00:00:00Z'), function(error, result) {
            should.not.exist(error);
            testClient.header.responseDatetime('valid', function(error, result) {
              should.not.exist(error);
              _.isEqual(new Date(result.response.headers['value']), new Date('2010-01-01T12:34:56Z')).should.be.exactly(true);
              testClient.header.responseDatetime('min', function(error, result) {
                should.not.exist(error);
                _.isEqual(new Date(result.response.headers['value']), new Date('0001-01-01T00:00:00Z')).should.be.exactly(true);
                done();
              });
            });
          });
        });
      });

      it('should send and receive byte array type headers', function(done) {
        var bytes = new Buffer('啊齄丂狛狜隣郎隣兀﨩');
        testClient.header.paramByte('valid', bytes, function(error, result) {
          should.not.exist(error);
          testClient.header.responseByte('valid', function(error, result) {
            should.not.exist(error);
            result.response.headers['value'].should.be.exactly(bytes.toString('base64'));
            done();
          });
        });
      });
    });
  });
});
