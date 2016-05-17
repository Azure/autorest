// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

import should = require('should');

import http = require('http');
import util = require('util');
import assert = require('assert');
import msRest = require('ms-rest');
import moment = require('moment');
import fs = require('fs');

import stream = require('stream');

import boolClient = require('../Expected/AcceptanceTests/BodyBoolean/autoRestBoolTestService');
import stringClient = require('../Expected/AcceptanceTests/BodyString/autoRestSwaggerBATService');
import integerClient = require('../Expected/AcceptanceTests/BodyInteger/autoRestIntegerTestService');
import compositeBoolIntClient = require('../Expected/AcceptanceTests/CompositeBoolIntClient/compositeBoolInt');
import numberClient = require('../Expected/AcceptanceTests/BodyNumber/autoRestNumberTestService');
import byteClient = require('../Expected/AcceptanceTests/BodyByte/autoRestSwaggerBATByteService');
import dateClient = require('../Expected/AcceptanceTests/BodyDate/autoRestDateTestService');
import dateTimeClient = require('../Expected/AcceptanceTests/BodyDateTime/autoRestDateTimeTestService');
import dateTimeRfc1123Client = require('../Expected/AcceptanceTests/BodyDateTimeRfc1123/autoRestRFC1123DateTimeTestService');
import durationClient = require('../Expected/AcceptanceTests/BodyDuration/autoRestDurationTestService');
import urlClient = require('../Expected/AcceptanceTests/Url/autoRestUrlTestService');
import fileClient = require('../Expected/AcceptanceTests/BodyFile/autoRestSwaggerBATFileService');
import arrayClient = require('../Expected/AcceptanceTests/BodyArray/autoRestSwaggerBATArrayService');
import dictionaryClient = require('../Expected/AcceptanceTests/BodyDictionary/autoRestSwaggerBATdictionaryService');
import dictionaryModels = require('../Expected/AcceptanceTests/BodyDictionary/models');
import httpClient = require('../Expected/AcceptanceTests/Http/autoRestHttpInfrastructureTestService');
import formDataClient = require('../Expected/AcceptanceTests/BodyFormData/autoRestSwaggerBATFormDataService');
import customBaseUriClient = require('../Expected/AcceptanceTests/CustomBaseUri/autoRestParameterizedHostTestClient');
import customBaseUriClientMoreOptions = require('../Expected/AcceptanceTests/CustomBaseUriMoreOptions/autoRestParameterizedCustomHostTestClient');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);

// TODO: Check types
var readStreamToBuffer = function(strm: stream.Readable, callback: (err: Error, result: Buffer) => void) {
  var bufs: Buffer[] = [];
  strm.on('data', function(d: Buffer) {
     bufs.push(d);
  });
  strm.on('end', function () {
    callback(null, Buffer.concat(bufs));
  });
};

var readStreamCountBytes = function(stream: stream.Readable, callback: (err: Error, result: number) => void) {
  var bytesRead = 0;
  stream.on('data', function (d: Buffer) {
   bytesRead = bytesRead + d.length;
  });

  stream.on('end', function() {
    callback(null, bytesRead);
  });
}

var clientOptions: msRest.ServiceClientOptions = {};
var baseUri = 'http://localhost:3000';
describe('nodejs', function () {

  describe('Swagger BAT', function () {
    describe('Custom BaseUri Client', function () {
      var customOptions = {
          host: 'host:3000'
      };
      var testClient = new customBaseUriClient(customOptions);
      it('should return 200', function (done) {
          testClient.paths.getEmpty('local', function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
      it('should throw due to bad "host", bad "account" and missing account', function (done) {
        testClient.host = 'nonexistent';
        testClient.paths.getEmpty('local', function (error, result, request, response) {
          should.exist(error);
          should.not.exist(result);
          testClient.host = 'host:3000';
          testClient.paths.getEmpty('bad', function (error, result, request, response) {
            should.exist(error);
            should.not.exist(result);
            testClient.paths.getEmpty(null, function (error, result, request, response) {
              should.exist(error);
              should.not.exist(result);
              done();
            });
          });
        });
      });
    });
    describe('Custom BaseUri Client with more options', function () {
      var customOptions = {
        dnsSuffix: 'host:3000'
      };
      var testClient = new customBaseUriClientMoreOptions('test12', customOptions);
      it('should return 200', function (done) {
          testClient.paths.getEmpty('http://lo','cal', 'key1', function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          done();
        });
      });
    });
    describe('Bool Client', function () {
      var testClient = new boolClient(baseUri, clientOptions);
      it('should get valid boolean values', function (done) {
        testClient.bool.getTrue(function (error, result) {
          should.not.exist(error);
          result.should.equal(true);
          testClient.bool.getFalse(function (error, result) {
            should.not.exist(error);
            result.should.equal(false);
            done();
          });
        });
      });

      it('should put valid boolean values', function (done) {
        testClient.bool.putTrue(true, function (error, result) {
          should.not.exist(error);
          testClient.bool.putFalse(false, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get null and invalid boolean value', function (done) {
        testClient.bool.getNull(function (error, result) {
          should.not.exist(result);
          testClient.bool.getInvalid(function (error, result) {
            should.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });
    });

    describe('Integer Client', function () {
      var testClient = new integerClient(baseUri, clientOptions);
      it('should put max value for 32 and 64 bit Integers', function (done) {
        testClient.intModel.putMax32((Math.pow(2, 32 - 1) - 1), function (error, result) {
          should.not.exist(error);
          testClient.intModel.putMax64(9223372036854776000, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should put min value for 32 and 64 bit Integers', function (done) {
        testClient.intModel.putMin32(-Math.pow(2, 32 - 1), function (error, result) {
          should.not.exist(error);
          testClient.intModel.putMin64(-9223372036854776000, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get null and invalid integer value', function (done) {
        testClient.intModel.getNull(function (error, result) {
          should.not.exist(result);
          testClient.intModel.getInvalid(function (error, result) {
            should.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });

      it('should get overflow and underflow for 32 bit integer value', function (done) {
        testClient.intModel.getOverflowInt32(function (error, result) {
          should.not.exist(error);
          result.should.equal(2147483656);
          testClient.intModel.getUnderflowInt32(function (error, result) {
            should.not.exist(error);
            result.should.equal(-2147483656);
            done();
          });
        });
      });

      it('should get overflow and underflow for 64 bit integer value', function (done) {
        testClient.intModel.getOverflowInt64(function (error, result) {
          should.not.exist(error);
          result.should.equal(9223372036854775910);
          testClient.intModel.getUnderflowInt64(function (error, result) {
            should.not.exist(error);
            result.should.equal(-9223372036854775910);
            done();
          });
        });
      });

      it('should put and get UnixTime date correctly', function (done) {
        var d = new Date('2016-04-13T00:00:00.000Z');
        testClient.intModel.putUnixTimeDate(d, function (error, result) {
          should.not.exist(error);
          testClient.intModel.getUnixTime(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, d);
            done();
          });
        });
      });

      it('should throw an error for invalid UnixTime date anf get null value for UnixTime', function (done) {
        testClient.intModel.getInvalidUnixTime(function (error, result) {
          should.exist(error);
          testClient.intModel.getNullUnixTime(function (error, result) {
            should.not.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });
    });

    describe('CompositeBoolInt Client', function () {
      var testClient = new compositeBoolIntClient(baseUri, clientOptions);
      it('should get valid boolean values', function (done) {
        testClient.bool.getTrue(function (error, result) {
          should.not.exist(error);
          result.should.equal(true);
          testClient.bool.getFalse(function (error, result) {
            should.not.exist(error);
            result.should.equal(false);
            done();
          });
        });
      });

      it('should put valid boolean values', function (done) {
        testClient.bool.putTrue(true, function (error, result) {
          should.not.exist(error);
          testClient.bool.putFalse(false, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get null and invalid boolean value', function (done) {
        testClient.bool.getNull(function (error, result) {
          should.not.exist(result);
          testClient.bool.getInvalid(function (error, result) {
            should.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });

      it('should put max value for 32 and 64 bit Integers', function (done) {
        testClient.intModel.putMax32((Math.pow(2, 32 - 1) - 1), function (error, result) {
          should.not.exist(error);
          testClient.intModel.putMax64(9223372036854776000, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should put min value for 32 and 64 bit Integers', function (done) {
        testClient.intModel.putMin32(-Math.pow(2, 32 - 1), function (error, result) {
          should.not.exist(error);
          testClient.intModel.putMin64(-9223372036854776000, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get null and invalid integer value', function (done) {
        testClient.intModel.getNull(function (error, result) {
          should.not.exist(result);
          testClient.intModel.getInvalid(function (error, result) {
            should.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });

      it('should get overflow and underflow for 32 bit integer value', function (done) {
        testClient.intModel.getOverflowInt32(function (error, result) {
          should.not.exist(error);
          result.should.equal(2147483656);
          testClient.intModel.getUnderflowInt32(function (error, result) {
            should.not.exist(error);
            result.should.equal(-2147483656);
            done();
          });
        });
      });

      it('should get overflow and underflow for 64 bit integer value', function (done) {
        testClient.intModel.getOverflowInt64(function (error, result) {
          should.not.exist(error);
          result.should.equal(9223372036854775910);
          testClient.intModel.getUnderflowInt64(function (error, result) {
            should.not.exist(error);
            result.should.equal(-9223372036854775910);
            done();
          });
        });
      });
    });

    describe('Number Client', function () {
      var testClient = new numberClient(baseUri, clientOptions);
      it('should put big float and double values', function (done) {
        testClient.number.putBigFloat(3.402823e+20, function (error, result) {
          should.not.exist(error);
          testClient.number.putBigDouble(2.5976931e+101, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get big float and double value', function (done) {
        testClient.number.getBigFloat(function (error, result) {
          should.not.exist(error);
          result.should.equal(3.402823e+20);
          testClient.number.getBigDouble(function (error, result) {
            should.not.exist(error);
            result.should.equal(2.5976931e+101);
            done();
          });
        });
      });

      it('should put small float and double values', function (done) {
        testClient.number.putSmallFloat(3.402823e-20, function (error, result) {
          should.not.exist(error);
          testClient.number.putSmallDouble(2.5976931e-101, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get small float and double value', function (done) {
        testClient.number.getSmallFloat(function (error, result) {
          should.not.exist(error);
          result.should.equal(3.402823e-20);
          testClient.number.getSmallDouble(function (error, result) {
            should.not.exist(error);
            result.should.equal(2.5976931e-101);
            done();
          });
        });
      });

      it('should put big positive and negative double value', function (done) {
        testClient.number.putBigDoublePositiveDecimal(99999999.99, function (error, result) {
          should.not.exist(error);
          testClient.number.putBigDoubleNegativeDecimal(-99999999.99, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get big positive and negative double value', function (done) {
        testClient.number.getBigDoublePositiveDecimal(function (error, result) {
          should.not.exist(error);
          result.should.equal(99999999.99);
          testClient.number.getBigDoubleNegativeDecimal(function (error, result) {
            should.not.exist(error);
            result.should.equal(-99999999.99);
            done();
          });
        });
      });

      it('should get null and invalid float and double values', function (done) {
        testClient.number.getNull(function (error, result) {
          should.not.exist(result);
          testClient.number.getInvalidFloat(function (error, result) {
            should.exist(error);
            should.not.exist(result);
            testClient.number.getInvalidDouble(function (error, result) {
              should.exist(error);
              should.not.exist(result);
              done();
            });
          });
        });
      });
    });

    describe('String Client', function () {
      var testClient = new stringClient(baseUri, clientOptions);
      it('should support valid null value', function (done) {
        testClient.string.getNull(function (error, result) {
          should.not.exist(result);
          testClient.string.putNull({ stringBody: null }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should support valid empty string value', function (done) {
        testClient.string.putEmpty('', function (error, result) {
          should.not.exist(error);
          testClient.string.getEmpty(function (error, result) {
            result.should.equal('');
            done();
          });
        });
      });

      it('should support valid MBC string value', function (done) {
        testClient.string.putMbcs('啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€', function (error, result) {
          should.not.exist(error);
          testClient.string.getMbcs(function (error, result) {
            result.should.equal('啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€');
            done();
          });
        });
      });

      it('should support whitespace string value', function (done) {
        testClient.string.putWhitespace('    Now is the time for all good men to come to the aid of their country    ', function (error, result) {
          should.not.exist(error);
          testClient.string.getWhitespace(function (error, result) {
            result.should.equal('    Now is the time for all good men to come to the aid of their country    ');
            done();
          });
        });
      });

      it('should support not provided value', function (done) {
        testClient.string.getNotProvided(function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          done();
        });
      });

      it('should support valid enum valid value', function (done) {
        testClient.enumModel.getNotExpandable(function (error, result) {
          should.not.exist(error);
          result.should.equal('red color');
          testClient.enumModel.putNotExpandable('red color', function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should correctly handle invalid values for enum', function (done) {
        testClient.enumModel.putNotExpandable('orange color', function (error, result) {
          should.exist(error);
          error.message.should.match(/.*is not a valid value.*/ig);
          done();
        });
      });

      it('should correctly deserialize base64 encoded string', function (done) {
        testClient.string.getBase64Encoded(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          result.toString('utf8').should.equal('a string that gets encoded with base64');
          done();
        });
      });

      it('should correctly handle null base64url encoded string', function (done) {
        testClient.string.getNullBase64UrlEncoded(function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          done();
        });
      });

      it('should correctly serialize and deserialize base64url encoded string', function (done) {
        testClient.string.getBase64UrlEncoded(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          result.toString('utf8').should.equal('a string that gets encoded with base64url');
          var buff = new Buffer('a string that gets encoded with base64url', 'utf8');
          testClient.string.putBase64UrlEncoded(buff, function (error, result) {
            should.not.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });
    });

    describe('Byte Client', function () {
      var testClient = new byteClient(baseUri, clientOptions);
      var bytes = new Buffer([255, 254, 253, 252, 251, 250, 249, 248, 247, 246]);
      it('should support valid null and empty value', function (done) {
        testClient.byteModel.getNull(function (error, result) {
          should.not.exist(result);
          should.not.exist(error);
          testClient.byteModel.getEmpty(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, new Buffer('', 'base64'));
            done();
          });
        });
      });

      //TODO Client does not consider the string as invalid byte
      it('should get invalid byte value', function (done) {
        testClient.byteModel.getInvalid(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result, new Buffer(':::SWAGGER::::', 'base64'));
          done();
        });
      });

      it('should support valid non Ascii byte values', function (done) {
        testClient.byteModel.putNonAscii(bytes, function (error, result) {
          should.not.exist(error);
          testClient.byteModel.getNonAscii(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, bytes);
            done();
          });
        });
      });
    });

    describe('Date Client', function () {
      var testClient = new dateClient(baseUri, clientOptions);
      it('should get min and max date', function (done) {
        testClient.dateModel.getMinDate(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(1);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(0);
          date.getUTCMinutes().should.equal(0);
          date.getUTCSeconds().should.equal(0);
          date.getUTCMilliseconds().should.equal(0);
          testClient.dateModel.getMaxDate(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            var date = result;
            date.getUTCFullYear().should.equal(9999);
            date.getUTCMonth().should.equal(11);
            date.getUTCDate().should.equal(31);
            date.getUTCHours().should.equal(0);
            date.getUTCMinutes().should.equal(0);
            date.getUTCSeconds().should.equal(0);
            date.getUTCMilliseconds().should.equal(0);
            done();
          });
        });
      });

      it('should properly handle underflow and overflow date', function (done) {
        testClient.dateModel.getUnderflowDate(function (error, result) {
          isNaN(result.valueOf()).should.equal(true);
          should.not.exist(error);
          testClient.dateModel.getOverflowDate(function (error, result) {
            isNaN(result.valueOf()).should.equal(true);
            should.not.exist(error);
            done();
          });
        });
      });

      it('should properly handle null value for Date', function (done) {
        testClient.dateModel.getNull(function (error, result) {
          should.not.exist(result);
          should.not.exist(error);
          done();
        });
      });

      it('should properly handle invalid Date value', function (done) {
        testClient.dateModel.getInvalidDate(function (error, result) {
          isNaN(result.valueOf()).should.equal(true);
          should.not.exist(error);
          done();
        });
      });

      it('should put min and max date', function (done) {
        testClient.dateModel.putMinDate(new Date('0001-01-01'), function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          testClient.dateModel.putMaxDate(new Date('9999-12-31'), function (error, result) {
            should.not.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });
    });

    describe('DateTime Client', function () {
      var testClient = new dateTimeClient(baseUri, clientOptions);
      it('should properly handle null value for DateTime', function (done) {
        testClient.datetime.getNull(function (error, result) {
          should.not.exist(result);
          should.not.exist(error);
          done();
        });
      });

      it('should properly handle invalid dateTime value', function (done) {
        testClient.datetime.getInvalid(function (error, result) {
          isNaN(result.valueOf()).should.equal(true);
          should.not.exist(error);
          done();
        });
      });

      it('should get uppercase and lowercase UTC max date time', function (done) {
        testClient.datetime.getUtcUppercaseMaxDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(9999);
          date.getUTCMonth().should.equal(11);
          date.getUTCDate().should.equal(31);
          date.getUTCHours().should.equal(23);
          date.getUTCMinutes().should.equal(59);
          date.getUTCSeconds().should.equal(59);
          date.getUTCMilliseconds().should.equal(999);
          testClient.datetime.getUtcLowercaseMaxDateTime(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            var date = result;
            date.getUTCFullYear().should.equal(9999);
            date.getUTCMonth().should.equal(11);
            date.getUTCDate().should.equal(31);
            date.getUTCHours().should.equal(23);
            date.getUTCMinutes().should.equal(59);
            date.getUTCSeconds().should.equal(59);
            done();
          });
        });
      });

      it('should get UTC min dateTime value', function (done) {
        testClient.datetime.getUtcMinDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(1);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(0);
          date.getUTCMinutes().should.equal(0);
          date.getUTCSeconds().should.equal(0);
          date.getUTCMilliseconds().should.equal(0);
          done();
        });
      });

      it('should get local negative and positive offset Min DateTime value', function (done) {
        testClient.datetime.getLocalNegativeOffsetMinDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(1);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(14);
          date.getUTCMinutes().should.equal(0);
          date.getUTCSeconds().should.equal(0);
          date.getUTCMilliseconds().should.equal(0);
          testClient.datetime.getLocalPositiveOffsetMinDateTime(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            var date = result;
            date.getUTCFullYear().should.equal(0);
            date.getUTCMonth().should.equal(11);
            date.getUTCDate().should.equal(31);
            date.getUTCHours().should.equal(10);
            date.getUTCMinutes().should.equal(0);
            date.getUTCSeconds().should.equal(0);
            date.getUTCMilliseconds().should.equal(0);
            done();
          });
        });
      });

      it('should get local negative offset lowercase and uppercase Max DateTime', function (done) {
        testClient.datetime.getLocalNegativeOffsetLowercaseMaxDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          assert.deepEqual(result, new Date('9999-12-31t23:59:59.9999999-14:00'));
          var date = result;
          date.getUTCFullYear().should.equal(10000);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(13);
          date.getUTCMinutes().should.equal(59);
          date.getUTCSeconds().should.equal(59);
          date.getUTCMilliseconds().should.equal(999);
          testClient.datetime.getLocalNegativeOffsetUppercaseMaxDateTime(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            assert.deepEqual(result, new Date('9999-12-31T23:59:59.9999999-14:00'));
            var date = result;
            date.getUTCFullYear().should.equal(10000);
            date.getUTCMonth().should.equal(0);
            date.getUTCDate().should.equal(1);
            date.getUTCHours().should.equal(13);
            date.getUTCMinutes().should.equal(59);
            date.getUTCSeconds().should.equal(59);
            date.getUTCMilliseconds().should.equal(999);
            done();
          });
        });
      });

      it('should get local positive offset lowercase and uppercase Max DateTime', function (done) {
        testClient.datetime.getLocalPositiveOffsetLowercaseMaxDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          assert.deepEqual(result, new Date('9999-12-31t23:59:59.9999999+14:00'));
          var date = result;
          date.getUTCFullYear().should.equal(9999);
          date.getUTCMonth().should.equal(11);
          date.getUTCDate().should.equal(31);
          date.getUTCHours().should.equal(9);
          date.getUTCMinutes().should.equal(59);
          date.getUTCSeconds().should.equal(59);
          date.getUTCMilliseconds().should.equal(999);
          testClient.datetime.getLocalPositiveOffsetUppercaseMaxDateTime(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            assert.deepEqual(result, new Date('9999-12-31T23:59:59.9999999+14:00'));
            var date = result;
            date.getUTCFullYear().should.equal(9999);
            date.getUTCMonth().should.equal(11);
            date.getUTCDate().should.equal(31);
            date.getUTCHours().should.equal(9);
            date.getUTCMinutes().should.equal(59);
            date.getUTCSeconds().should.equal(59);
            date.getUTCMilliseconds().should.equal(999);
            done();
          });
        });
      });

      it('should get overflow and underflow', function (done) {
        testClient.datetime.getOverflow(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(10000);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(13);
          date.getUTCMinutes().should.equal(59);
          date.getUTCSeconds().should.equal(59);
          date.getUTCMilliseconds().should.equal(999);
          testClient.datetime.getUnderflow(function (error, result) {
            isNaN(result.valueOf()).should.equal(true);
            should.not.exist(error);
            done();
          });
        });
      });

      it('should put UTC min and max date time', function (done) {
        testClient.datetime.putUtcMinDateTime('0001-01-01T00:00:00Z', function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          testClient.datetime.putUtcMaxDateTime('9999-12-31T23:59:59.9999999Z', function (error, result) {
            should.not.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });

      it('should put local negative and positive offset min DateTime', function (done) {
        testClient.datetime.putLocalNegativeOffsetMinDateTime('0001-01-01T00:00:00-14:00', function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          testClient.datetime.putLocalPositiveOffsetMinDateTime('0001-01-01T00:00:00+14:00', function (error, result) {
            should.not.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });

      it('should put local negative offset max DateTime', function (done) {
        testClient.datetime.putLocalNegativeOffsetMaxDateTime('9999-12-31T23:59:59.9999999-14:00', function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          done();
        });
      });

      it('should put local positive offset max Date', function (done) {
        testClient.datetime.putLocalPositiveOffsetMaxDateTime('9999-12-31t23:59:59.9999999+14:00', function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          done();
        });
      });
    });

    describe('DateTimeRfc1123 Client', function () {
      var testClient = new dateTimeRfc1123Client(baseUri, clientOptions);
      it('should properly handle null value for DateTimeRfc1123', function (done) {
        testClient.datetimerfc1123.getNull(function (error, result) {
          should.not.exist(result);
          should.not.exist(error);
          done();
        });
      });

      it('should properly handle invalid dateTimeRfc1123 value', function (done) {
        testClient.datetimerfc1123.getInvalid(function (error, result) {
          isNaN(result.valueOf()).should.equal(true);
          should.not.exist(error);
          done();
        });
      });

      it('should get uppercase and lowercase UTC max date time dateTimeRfc1123', function (done) {
        testClient.datetimerfc1123.getUtcUppercaseMaxDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(9999);
          date.getUTCMonth().should.equal(11);
          date.getUTCDate().should.equal(31);
          date.getUTCHours().should.equal(23);
          date.getUTCMinutes().should.equal(59);
          date.getUTCSeconds().should.equal(59);
          testClient.datetimerfc1123.getUtcLowercaseMaxDateTime(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            var date = result;
            date.getUTCFullYear().should.equal(9999);
            date.getUTCMonth().should.equal(11);
            date.getUTCDate().should.equal(31);
            date.getUTCHours().should.equal(23);
            date.getUTCMinutes().should.equal(59);
            date.getUTCSeconds().should.equal(59);
            done();
          });
        });
      });

      it('should get UTC min dateTimeRfc1123 value', function (done) {
        testClient.datetimerfc1123.getUtcMinDateTime(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          done();
          //TODO: NodeJS doesn't deserialize this time correctly
          var dateFormat = 'ddd, DD MMM YYYY HH:mm:ss';
          var myMoment = moment.utc('Mon, 01 Jan 0001 00:00:00 GMT', dateFormat);
          should.not.exist(myMoment.toDate().toUTCString());

          date.getUTCFullYear().should.equal(1);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(0);
          date.getUTCMinutes().should.equal(0);
          date.getUTCSeconds().should.equal(0);
          date.getUTCMilliseconds().should.equal(0);
          done();
        });
      });
      
      it('should get overflow and underflow', function (done) {
        testClient.datetimerfc1123.getOverflow(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          var date = result;
          date.getUTCFullYear().should.equal(10000);
          date.getUTCMonth().should.equal(0);
          date.getUTCDate().should.equal(1);
          date.getUTCHours().should.equal(0);
          date.getUTCMinutes().should.equal(0);
          date.getUTCSeconds().should.equal(0);
          testClient.datetimerfc1123.getUnderflow(function (error, result) {
            isNaN(result.valueOf()).should.equal(true);
            should.not.exist(error);
            done();
          });
        });
      });

      it('should put UTC min and max dateTimeRfc1123', function (done) {
        testClient.datetimerfc1123.putUtcMinDateTime(new Date('Mon, 01 Jan 0001 00:00:00 GMT'), function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          testClient.datetimerfc1123.putUtcMaxDateTime(new Date('Fri, 31 Dec 9999 23:59:59 GMT'), function (error, result) {
            should.not.exist(error);
            should.not.exist(result);
            done();
          });
        });
      });
    });

    describe('Duration Client', function () {
      var testClient = new durationClient(baseUri, clientOptions);
      it('should properly handle null value for Duration', function (done) {
        testClient.duration.getNull(function (error, result) {
          should.not.exist(result);
          should.not.exist(error);
          done();
        });
      });

      it('should properly handle invalid value for Duration', function (done) {
        testClient.duration.getInvalid(function (error, result) {
          //For some reason moment.js allows non-ISO strings and will just construct a duration of length 0, so we don't expect an error here, but the result
          //should be duration of length 0
          should.not.exist(error);
          should.equal(result.asSeconds(), 0);
          done();
        });
      });

      it('should properly handle positive value for Duration', function (done) {
        testClient.duration.getPositiveDuration(function (error, result) {
          should.exist(result);
          should.not.exist(error);
          should.equal(result.asSeconds(), moment.duration('P3Y6M4DT12H30M5S').asSeconds());
          done();
        });
      });

      it('should properly put positive value for Duration', function (done) {
        var duration = moment.duration({days: 123, hours: 22, minutes: 14, seconds: 12, milliseconds: 11});
        testClient.duration.putPositiveDuration(duration, function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          done();
        });
      });
    });

    describe('Array Client', function () {

      describe('for primitive types', function () {
        var testClient = new arrayClient(baseUri, clientOptions);
        it('should get and put empty arrays', function (done) {
          testClient.arrayModel.getEmpty(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, []);
            testClient.arrayModel.putEmpty([], function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should handle null and invalid value for arrays', function (done) {
          testClient.arrayModel.getNull(function (error, result) {
            should.not.exist(error);
            assert.equal(result, null);
            testClient.arrayModel.getInvalid(function (error, result) {
              should.exist(error);
              should.not.exist(result);
              done();
            });
          });
        });

        it('should get base64url arrays', function (done) {
          var base64Url1 = new Buffer('a string that gets encoded with base64url', 'utf8');
          var base64Url2 = new Buffer('test string', 'utf8');
          var base64Url3 = new Buffer('Lorem ipsum', 'utf8');
          var arr = [base64Url1, base64Url2, base64Url3];
          testClient.arrayModel.getBase64Url(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            assert.deepEqual(result, arr);
            done();
          });
        });

        it('should get and put boolean arrays', function (done) {
          var boolArray = [true, false, false, true];
          testClient.arrayModel.getBooleanTfft(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, boolArray);
            testClient.arrayModel.putBooleanTfft(boolArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getBooleanInvalidNull(function (error, result) {
                should.not.exist(error);
                assert.deepEqual(result, [true, null, false]);
                testClient.arrayModel.getBooleanInvalidString(function (error, result) {
                  should.not.exist(error);
                  assert.deepEqual(result, [true, 'boolean', false]);
                  done();
                });
              });
            });
          });
        });

        it('should get and put integer arrays', function (done) {
          var testArray = [1, -1, 3, 300];
          testClient.arrayModel.getIntegerValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putIntegerValid(testArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getIntInvalidNull(function (error, result) {
                should.not.exist(error);
                testClient.arrayModel.getIntInvalidString(function (error, result) {
                  should.not.exist(error);
                  done();
                });
              });
            });
          });
        });

        it('should get and put long arrays', function (done) {
          var testArray = [1, -1, 3, 300];
          testClient.arrayModel.getLongValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putLongValid(testArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getLongInvalidNull(function (error, result) {
                should.not.exist(error);
                testClient.arrayModel.getLongInvalidString(function (error, result) {
                  should.not.exist(error);
                  done();
                });
              });
            });
          });
        });

        it('should get and put float arrays', function (done) {
          var testArray = [0, -0.01, -1.2e20];
          testClient.arrayModel.getFloatValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putFloatValid(testArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getFloatInvalidNull(function (error, result) {
                should.not.exist(error);
                testClient.arrayModel.getFloatInvalidString(function (error, result) {
                  should.not.exist(error);
                  done();
                });
              });
            });
          });
        });

        it('should get and put double arrays', function (done) {
          var testArray = [0, -0.01, -1.2e20];
          testClient.arrayModel.getDoubleValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putDoubleValid(testArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getDoubleInvalidNull(function (error, result) {
                should.not.exist(error);
                testClient.arrayModel.getDoubleInvalidString(function (error, result) {
                  should.not.exist(error);
                  done();
                });
              });
            });
          });
        });

        it('should get and put string arrays', function (done) {
          var testArray = ['foo1', 'foo2', 'foo3'];
          testClient.arrayModel.getStringValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putStringValid(testArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getStringWithNull(function (error, result) {
                should.not.exist(error);
                testClient.arrayModel.getStringWithInvalid(function (error, result) {
                  should.not.exist(error);
                  done();
                });
              });
            });
          });
        });

        it('should get and put uuid arrays', function (done) {
            var testArray = ["6dcc7237-45fe-45c4-8a6b-3a8a3f625652", "d1399005-30f7-40d6-8da6-dd7c89ad34db", "f42f6aa1-a5bc-4ddf-907e-5f915de43205"];
            testClient.arrayModel.getUuidValid(function (error, result) {
                should.not.exist(error);
                assert.deepEqual(result, testArray);
                testClient.arrayModel.putUuidValid(testArray, function (error, result) {
                    should.not.exist(error);
                    testClient.arrayModel.getUuidInvalidChars(function (error, result) {
                        should.not.exist(error);
                        done();
                    });
                });
            });
        });

        it('should get and put date arrays', function (done) {
          var testArray = [new Date('2000-12-01'), new Date('1980-01-02'), new Date('1492-10-12')];
          testClient.arrayModel.getDateValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putDateValid(testArray, function (error, result) {
              should.not.exist(error);
            testClient.arrayModel.getDateInvalidNull(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, [new Date('2012-01-01'), null, new Date('1776-07-04')]);
              testClient.arrayModel.getDateInvalidChars(function (error, result) {
                should.not.exist(error);
                JSON.stringify(result).should.equal(JSON.stringify([new Date('2011-03-22'), new Date('date')]));
                done();
              });
            });
            });
          });
        });

        it('should get and put dateTime arrays', function (done) {
          var testArray = [new Date('2000-12-01t00:00:01z'), new Date('1980-01-02T01:11:35+01:00'), new Date('1492-10-12T02:15:01-08:00')];
          testClient.arrayModel.getDateTimeValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putDateTimeValid(testArray, function (error, result) {
              should.not.exist(error);
              testClient.arrayModel.getDateTimeInvalidNull(function (error, result) {
                should.not.exist(error);
                assert.deepEqual(result, [new Date('2000-12-01t00:00:01z'), null]);
                testClient.arrayModel.getDateTimeInvalidChars(function (error, result) {
                  should.not.exist(error);
                  JSON.stringify(result).should.equal(JSON.stringify([new Date('2000-12-01t00:00:01z'), new Date('date-time')]));
                  done();
                });
              });
            });
          });
        });
         
        it('should get and put dateTimeRfc1123 arrays', function (done) {
          var testArray = [new Date('Fri, 01 Dec 2000 00:00:01 GMT'), new Date('Wed, 02 Jan 1980 00:11:35 GMT'), new Date('Wed, 12 Oct 1492 10:15:01 GMT')];
          testClient.arrayModel.getDateTimeRfc1123Valid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putDateTimeRfc1123Valid(testArray, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get and put duration arrays', function (done) {
          var testArray = [moment.duration('P123DT22H14M12.011S'), moment.duration('P5DT1H')];
          testClient.arrayModel.getDurationValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putDurationValid(testArray, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get and put byte arrays', function (done) {
          var bytes1 = new Buffer([255, 255, 255, 250]);
          var bytes2 = new Buffer([1, 2, 3]);
          var bytes3 = new Buffer([37, 41, 67]);
          var testArray = [bytes1, bytes2, bytes3];
          testClient.arrayModel.getByteValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putByteValid(testArray, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get byte arrays with null values', function (done) {
          var testArray = [new Buffer([171, 172, 173]), null];
          testClient.arrayModel.getByteInvalidNull(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            assert.deepEqual(result, testArray);
            done();
          });
        });
      });

      describe('for complex types', function () {
        var testClient = new arrayClient(baseUri, clientOptions);
        it('should get null and empty complex types in array', function (done) {
          testClient.arrayModel.getComplexEmpty(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, []);
            testClient.arrayModel.getComplexNull(function (error, result) {
              should.not.exist(error);
              assert.equal(result, null);
              done();
            });
          });
        });

        it('should get complex items with empty and null values in array', function (done) {
          var testNull = [{ 'integer': 1, 'string': '2' }, null, { 'integer': 5, 'string': '6' }];
          var testEmpty = [{ 'integer': 1, 'string': '2' }, {}, { 'integer': 5, 'string': '6' }];
          testClient.arrayModel.getComplexItemNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testNull);
            testClient.arrayModel.getComplexItemEmpty(function (error, result) {
              should.not.exist(error);
              JSON.stringify(result).should.equal(JSON.stringify(testEmpty));
              done();
            });
          });
        });

        it('should get and put valid complex items in arrays', function (done) {
          var testArray = [{ 'integer': 1, 'string': '2' }, { 'integer': 3, 'string': '4' }, { 'integer': 5, 'string': '6' }];
          testClient.arrayModel.getComplexValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putComplexValid(testArray, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      describe('for array of arrays', function () {
        var testClient = new arrayClient(baseUri, clientOptions);
        it('should get null and empty array in an array', function (done) {
          testClient.arrayModel.getArrayNull(function (error, result) {
            should.not.exist(error);
            assert.equal(result, null);
            testClient.arrayModel.getArrayEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, []);
              done();
            });
          });
        });

        it('should get arrays with empty and null items in an array', function (done) {
          var testNull = [['1', '2', '3'], null, ['7', '8', '9']];
          var testEmpty = [['1', '2', '3'], [], ['7', '8', '9']];
          testClient.arrayModel.getArrayItemNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testNull);
            testClient.arrayModel.getArrayItemEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, testEmpty);
              done();
            });
          });
        });

        it('should get and put valid array items in an array', function (done) {
          var testArray = [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']];
          testClient.arrayModel.getArrayValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putArrayValid(testArray, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      describe('for array of dictionaries', function () {
        var testClient = new arrayClient(baseUri, clientOptions);
        it('should get null and empty dictionary in an array', function (done) {
          testClient.arrayModel.getDictionaryNull(function (error, result) {
            should.not.exist(error);
            assert.equal(result, null);
            testClient.arrayModel.getDictionaryEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, []);
              done();
            });
          });
        });

        it('should get array of dictionaries with empty and null items in an array', function (done) {
          var testNull = [{ '1': 'one', '2': 'two', '3': 'three' }, null, { '7': 'seven', '8': 'eight', '9': 'nine' }];
          var testEmpty = [{ '1': 'one', '2': 'two', '3': 'three' }, {}, { '7': 'seven', '8': 'eight', '9': 'nine' }];
          testClient.arrayModel.getDictionaryItemNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testNull);
            testClient.arrayModel.getDictionaryItemEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, testEmpty);
              done();
            });
          });
        });

        it('should get and put valid dicitonary items in arrays', function (done) {
          var testArray: { [propertyName: string]: string }[] =
            [{ '1': 'one', '2': 'two', '3': 'three' }, { '4': 'four', '5': 'five', '6': 'six' }, { '7': 'seven', '8': 'eight', '9': 'nine' }];
          testClient.arrayModel.getDictionaryValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testArray);
            testClient.arrayModel.putDictionaryValid(testArray, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });
    });

    describe('Dictionary Client', function () {

      describe('for primitive types', function () {
        var testClient = new dictionaryClient(baseUri, clientOptions);
        it('should get and put empty dictionaries', function (done) {
          testClient.dictionary.getEmpty(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, {});
            testClient.dictionary.putEmpty({}, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should handle null and invalid value for dictionaries', function (done) {
          testClient.dictionary.getNull(function (error, result) {
            should.not.exist(error);
            assert.equal(result, null);
            testClient.dictionary.getInvalid(function (error, result) {
              should.exist(error);
              should.not.exist(result);
              done();
            });
          });
        });

        it('should handle null value, null key and empty key for dictionaries', function (done) {
          testClient.dictionary.getNullValue(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, { "key1": null });
            testClient.dictionary.getNullKey(function (error, result) {
              should.exist(error);
              testClient.dictionary.getEmptyStringKey(function (error, result) {
                should.not.exist(error);
                assert.deepEqual(result, { "": "val1" });
                done();
              });
            });
          });
        });

        it('should get base64url dictionaries', function (done) {
          var base64Url1 = new Buffer('a string that gets encoded with base64url', 'utf8');
          var base64Url2 = new Buffer('test string', 'utf8');
          var base64Url3 = new Buffer('Lorem ipsum', 'utf8');
          var dict: { [propertyName: string]: Buffer } = { "0": base64Url1, "1": base64Url2, "2": base64Url3 };
          testClient.dictionary.getBase64Url(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, dict);
            done();
          });
        });

        it('should get and put boolean dictionaries', function (done) {
          var boolDictionary: { [propertyName: string]: boolean } = { "0": true, "1": false, "2": false, "3": true };
          testClient.dictionary.getBooleanTfft(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, boolDictionary);
            testClient.dictionary.putBooleanTfft(boolDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get boolean dictionaries with null value', function (done) {
          var boolDictionary: { [propertyName: string]: boolean } = { "0": true, "1": null, "2": false };
          testClient.dictionary.getBooleanInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, boolDictionary);
            done();
          });
        });

        it('should get boolean dictionaries with string value', function (done) {
          var boolDictionary = { "0": true, "1": "boolean", "2": false };
          testClient.dictionary.getBooleanInvalidString(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, boolDictionary);
            done();
          });
        });

        it('should get and put integer dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: number } = { "0": 1, "1": -1, "2": 3, "3": 300 };
          testClient.dictionary.getIntegerValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putIntegerValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get integer dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: number } = { "0": 1, "1": null, "2": 0 };
          testClient.dictionary.getIntInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get integer dictionaries with string value', function (done) {
          var testDictionary = { "0": 1, "1": "integer", "2": 0 };
          testClient.dictionary.getIntInvalidString(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get and put long dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: number }  = { "0": 1, "1": -1, "2": 3, "3": 300 };
          testClient.dictionary.getLongValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putLongValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get long dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: number } = { "0": 1, "1": null, "2": 0 };
          testClient.dictionary.getLongInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get long dictionaries with string value', function (done) {
          var testDictionary = { "0": 1, "1": "integer", "2": 0 };
          testClient.dictionary.getLongInvalidString(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get and put float dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: number } = { "0": 0, "1": -0.01, "2": -1.2e20 };
          testClient.dictionary.getFloatValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putFloatValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get float dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: number }  = { "0": 0.0, "1": null, "2": -1.2e20 };
          testClient.dictionary.getFloatInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get float dictionaries with string value', function (done) {
          var testDictionary = { "0": 1, "1": "number", "2": 0 };
          testClient.dictionary.getFloatInvalidString(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get and put double dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: number } = { "0": 0, "1": -0.01, "2": -1.2e20 };
          testClient.dictionary.getDoubleValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putDoubleValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get double dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: number } = { "0": 0.0, "1": null, "2": -1.2e20 };
          testClient.dictionary.getDoubleInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get double dictionaries with string value', function (done) {
          var testDictionary = { "0": 1, "1": "number", "2": 0 };
          testClient.dictionary.getDoubleInvalidString(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get and put string dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: string } = { "0": "foo1", "1": "foo2", "2": "foo3" };
          testClient.dictionary.getStringValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putStringValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get string dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: string } = { "0": "foo", "1": null, "2": "foo2" };
          testClient.dictionary.getStringWithNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get string dictionaries with number as string value', function (done) {
          var testDictionary = { "0": "foo", "1": 123, "2": "foo2" };
          testClient.dictionary.getStringWithInvalid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get and put date dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: Date } = { 0: new Date('2000-12-01'), 1: new Date('1980-01-02'), 2: new Date('1492-10-12') };
          testClient.dictionary.getDateValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putDateValid(testDictionary, function (error, result) {
              should.not.exist(error);
            done();
            });
          });
        });

        it('should get date dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: Date } = { "0": new Date("2012-01-01"), "1": null, "2": new Date("1776-07-04") };
          testClient.dictionary.getDateInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get date dictionaries with string value', function (done) {
          var testDictionary: { [propertyName: string]: Date } = { "0": new Date("2011-03-22"), "1": new Date("date") };
          testClient.dictionary.getDateInvalidChars(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(util.inspect(result), util.inspect(testDictionary));
            done();
          });
        });

        it('should get and put dateTime dictionaries', function (done) {
          var getDictionary: { [propertyName: string]: Date } =
            { 0: new Date('2000-12-01t00:00:01z'), 1: new Date('1980-01-02T00:11:35+01:00'), 2: new Date('1492-10-12T10:15:01-08:00') };
          var putDictionary: { [propertyName: string]: Date } =
            { 0: new Date('2000-12-01T00:00:01Z'), 1: new Date('1980-01-01T23:11:35Z'), 2: new Date('1492-10-12T18:15:01Z') };
          testClient.dictionary.getDateTimeValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, getDictionary);
            testClient.dictionary.putDateTimeValid(putDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get and put dateTimeRfc1123 dictionaries', function (done) {
          var dictionary: { [propertyName: string]: Date } =
            { 0: new Date('Fri, 01 Dec 2000 00:00:01 GMT'), 1: new Date('Wed, 02 Jan 1980 00:11:35 GMT'), 2: new Date('Wed, 12 Oct 1492 10:15:01 GMT') };
          testClient.dictionary.getDateTimeRfc1123Valid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, dictionary);
            testClient.dictionary.putDateTimeRfc1123Valid(dictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get and put duration dictionaries', function (done) {
          var dictionary: { [propertyName: string]: moment.Duration } =
            { 0: moment.duration('P123DT22H14M12.011S'), 1: moment.duration('P5DT1H') };
          testClient.dictionary.getDurationValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, dictionary);
            testClient.dictionary.putDurationValid(dictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get dateTime dictionaries with null value', function (done) {
          var testDictionary: { [propertyName: string]: Date } = { "0": new Date("2000-12-01t00:00:01z"), "1": null };
          testClient.dictionary.getDateTimeInvalidNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });

        it('should get dateTime dictionaries with string value', function (done) {
          var testDictionary: { [propertyName: string]: Date } = { "0": new Date("2000-12-01t00:00:01z"), "1": new Date("date-time") };
          testClient.dictionary.getDateTimeInvalidChars(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(util.inspect(result), util.inspect(testDictionary));
            done();
          });
        });

        it('should get and put byte dictionaries', function (done) {
          var bytes1 = new Buffer([255, 255, 255, 250]);
          var bytes2 = new Buffer([1, 2, 3]);
          var bytes3 = new Buffer([37, 41, 67]);
          var testDictionary: { [propertyName: string]: Buffer } = { 0: bytes1, 1: bytes2, 2: bytes3 };
          testClient.dictionary.getByteValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putByteValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });

        it('should get byte dictionaries with null values', function (done) {
          var testDictionary: { [propertyName: string]: Buffer } = { 0: new Buffer([171, 172, 173]), 1: null };
          testClient.dictionary.getByteInvalidNull(function (error, result) {
            should.not.exist(error);
            should.exist(result);
            assert.deepEqual(result, testDictionary);
            done();
          });
        });
      });

      describe('for complex types', function () {
        var testClient = new dictionaryClient(baseUri, clientOptions);
        it('should get null and empty complex types in dictionary', function (done) {
          testClient.dictionary.getComplexEmpty(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, {});
            testClient.dictionary.getComplexNull(function (error, result) {
              should.not.exist(error);
              assert.equal(result, null);
              done();
            });
          });
        });

        it('should get complex items with empty and null values in dictionary', function (done) {
          var testNull: { [propertyName: string]: dictionaryModels.Widget } = { 0: { 'integer': 1, 'string': '2' }, 1: null, 2: { 'integer': 5, 'string': '6' } };
          var testEmpty = { 0: { 'integer': 1, 'string': '2' }, 1: {}, 2: { 'integer': 5, 'string': '6' } };
          testClient.dictionary.getComplexItemNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testNull);
            testClient.dictionary.getComplexItemEmpty(function (error, result) {
              should.not.exist(error);
              JSON.stringify(result).should.equal(JSON.stringify(testEmpty));
              done();
            });
          });
        });

        it('should get and put valid complex items in dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: dictionaryModels.Widget } = { 0: { 'integer': 1, 'string': '2' }, 1: { 'integer': 3, 'string': '4' }, 2: { 'integer': 5, 'string': '6' } };
          testClient.dictionary.getComplexValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putComplexValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      describe('for dictionary of arrays', function () {
        var testClient = new dictionaryClient(baseUri, clientOptions);
        it('should get null and empty array in dictionary', function (done) {
          testClient.dictionary.getArrayNull(function (error, result) {
            should.not.exist(error);
            assert.equal(result, null);
            testClient.dictionary.getArrayEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, {});
              done();
            });
          });
        });

        it('should get arrays with empty and null items in dictionary', function (done) {
          var testNull: { [propertyName: string]: string[] } = { 0: ['1', '2', '3'], 1: null, 2: ['7', '8', '9'] };
          var testEmpty: { [propertyName: string]: string[] }  = { 0: ['1', '2', '3'], 1: [], 2: ['7', '8', '9'] };
          testClient.dictionary.getArrayItemNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testNull);
            testClient.dictionary.getArrayItemEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, testEmpty);
              done();
            });
          });
        });

        it('should get and put valid array items in dictionary', function (done) {
          var testDictionary: { [propertyName: string]: string[] } = { 0: ['1', '2', '3'], 1: ['4', '5', '6'], 2: ['7', '8', '9'] };
          testClient.dictionary.getArrayValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putArrayValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      describe('for dictionary of dictionaries', function () {
        var testClient = new dictionaryClient(baseUri, clientOptions);
        it('should get null and empty dictionary in dictionary', function (done) {
          testClient.dictionary.getDictionaryNull(function (error, result) {
            should.not.exist(error);
            assert.equal(result, null);
            testClient.dictionary.getDictionaryEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, {});
              done();
            });
          });
        });

        it('should get dictionaries with empty and null items in dictionary', function (done) {
          var testNull: { [propertyName: string]: { [propertyName: string]: string } } =
            { 0: { '1': 'one', '2': 'two', '3': 'three' }, 1: null, 2: { '7': 'seven', '8': 'eight', '9': 'nine' } };
          var testEmpty: { [propertyName: string]: { [propertyName: string]: string } } =
            { 0: { '1': 'one', '2': 'two', '3': 'three' }, 1: {}, 2: { '7': 'seven', '8': 'eight', '9': 'nine' } };
          testClient.dictionary.getDictionaryItemNull(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testNull);
            testClient.dictionary.getDictionaryItemEmpty(function (error, result) {
              should.not.exist(error);
              assert.deepEqual(result, testEmpty);
              done();
            });
          });
        });

        it('should get and put valid dicitonary items in dictionaries', function (done) {
          var testDictionary: { [propertyName: string]: { [propertyName: string]: string} } =
            { 0: { '1': 'one', '2': 'two', '3': 'three' }, 1: { '4': 'four', '5': 'five', '6': 'six' }, 2: { '7': 'seven', '8': 'eight', '9': 'nine' } };
          testClient.dictionary.getDictionaryValid(function (error, result) {
            should.not.exist(error);
            assert.deepEqual(result, testDictionary);
            testClient.dictionary.putDictionaryValid(testDictionary, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });
    });

    describe('Files Client', function() {
      var testClient = new fileClient(baseUri, clientOptions);
      it('should correctly deserialize binary streams', function(done) {
        testClient.files.getFile(function(error, result) {
          should.not.exist(error);
          should.exist(result);
          readStreamToBuffer(result, function(err, buff) {
            should.not.exist(err);
            assert.deepEqual(buff, fs.readFileSync(__dirname + '/sample.png'));
            done();
          });
        });
      });

      it('should correctly deserialize empty streams', function (done) {
        testClient.files.getEmptyFile(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          readStreamToBuffer(result, function (err, buff) {
            should.not.exist(err);
            buff.length.should.equal(0);
            done();
          });
        });
      });
      
      it('should correctly deserialize large streams', function (done) {
        testClient.files.getFileLarge(function (error, result) {
          should.not.exist(error);
          should.exist(result);
          readStreamCountBytes(result, function (err, byteCount) {
            should.not.exist(err);
            byteCount.should.equal(3000 * 1024 * 1024);
            done();
          });
        });
      });
    });

    describe('Form Data Client', function() {
      var testClient = new formDataClient(baseUri, clientOptions);
      it('should correctly accept file via form-data', function(done) {
        testClient.formdata.uploadFile(fs.createReadStream(__dirname + '/sample.png'), 'sample.png', function(error, result) {
          should.not.exist(error);
          should.exist(result);
          readStreamToBuffer(result, function(err, buff) {
            should.not.exist(err);
            assert.deepEqual(buff, fs.readFileSync(__dirname + '/sample.png'));
            done();
          });
        });
      });

      it('should correctly accept file via body', function(done) {
        testClient.formdata.uploadFileViaBody(fs.createReadStream(__dirname + '/sample.png'), function(error, result) {
          should.not.exist(error);
          should.exist(result);
          readStreamToBuffer(result, function(err, buff) {
            should.not.exist(err);
            assert.deepEqual(buff, fs.readFileSync(__dirname + '/sample.png'));
            done();
          });
        });
      });
    });

    describe('Url Client', function () {
      var testClient = new urlClient('globalStringPath', baseUri, clientOptions);
      testClient.globalStringQuery = 'globalStringQuery';
      it('should work when path has null, empty, and multi-byte byte values', function (done) {
        testClient.paths.byteNull(null, function (error, result) {
          should.exist(error);
          should.not.exist(result);
          testClient.paths.byteEmpty(new Buffer(''), function (error, result) {
            should.not.exist(error);
            testClient.paths.byteMultiByte(new Buffer('啊齄丂狛狜隣郎隣兀﨩'), function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      it('should work when path has string', function (done) {
        testClient.paths.stringEmpty('', function (error, result) {
          should.not.exist(error);
          testClient.paths.stringNull(null, function (error, result) {
            should.exist(error);
            testClient.paths.stringUrlEncoded('begin!*\'();:@ &=+$,/?#[]end', function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      it('should work when path has base64url encoded string', function (done) {
        testClient.paths.base64Url(new Buffer('lorem', 'utf8'), function (error, result) {
          should.not.exist(error);
          should.not.exist(result);
          done();
        });
      });

      it('should work when path has a paramaeter in UnixTime format', function (done) {
        testClient.paths.unixTimeUrl(new Date('2016-04-13T00:00:00.000Z'), function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should work when path has datetime', function (done) {
        testClient.paths.dateTimeValid(new Date('2012-01-01T01:01:01Z'), function (error, result) {
          should.not.exist(error);
          testClient.paths.dateTimeNull(null, function (error, result) {
            should.exist(error);
            done();
          });
        });
      });

      it('should work when path has date', function (done) {
        testClient.paths.dateValid(function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should work when query has date', function (done) {
        testClient.queries.dateValid(function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should work when path has enum', function (done) {
        testClient.paths.enumValid('', function (error, result) {
          should.exist(error);
          error.message.should.match(/.*cannot be null or undefined.*/ig);
          testClient.paths.enumNull(null, function (error, result) {
            should.exist(error);
            testClient.paths.enumValid('green color', function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });

      it('should work when path has bool', function (done) {
        testClient.paths.getBooleanTrue(true, function (error, result) {
          should.not.exist(error);
          testClient.paths.getBooleanFalse(false, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should work when path has double decimal values', function (done) {
        testClient.paths.doubleDecimalNegative(-9999999.999, function (error, result) {
          should.not.exist(error);
          testClient.paths.doubleDecimalPositive(9999999.999, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should work when path has float values', function (done) {
        testClient.paths.floatScientificNegative(-1.034e-20, function (error, result) {
          should.not.exist(error);
          testClient.paths.floatScientificPositive(1.034e20, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should work when path has integer values', function (done) {
        testClient.paths.getIntNegativeOneMillion(-1000000, function (error, result) {
          should.not.exist(error);
          testClient.paths.getIntOneMillion(1000000, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should work when path has big integer values', function (done) {
        testClient.paths.getNegativeTenBillion(-10000000000, function (error, result) {
          should.not.exist(error);
          testClient.paths.getTenBillion(10000000000, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should work when use values in different portion of url', function (done) {
        var optionalParams = { localStringQuery: 'localStringQuery', pathItemStringQuery : 'pathItemStringQuery' };
        testClient.pathItems.getAllWithValues('localStringPath', 'pathItemStringPath', optionalParams, function (error, result) {
          should.not.exist(error);
          done();
        });
      });
      it('should work when use null values in different portion of url', function (done) {
        testClient.globalStringQuery = null;
        var optionalParams = { localStringQuery: <string> null, pathItemStringQuery : 'pathItemStringQuery' };
        testClient.pathItems.getGlobalAndLocalQueryNull('localStringPath', 'pathItemStringPath', optionalParams, function (error, result) {
          should.not.exist(error);
          optionalParams = { localStringQuery: 'localStringQuery', pathItemStringQuery : 'pathItemStringQuery' };
          testClient.pathItems.getGlobalQueryNull('localStringPath', 'pathItemStringPath', optionalParams, function (error, result) {
            should.not.exist(error);
            testClient.globalStringQuery = 'globalStringQuery';
            optionalParams = { localStringQuery: null, pathItemStringQuery : null };
            testClient.pathItems.getLocalPathItemQueryNull('localStringPath', 'pathItemStringPath', optionalParams, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });
      it('should work when query has bool', function (done) {
        testClient.queries.getBooleanTrue(function (error, result) {
          should.not.exist(error);
          testClient.queries.getBooleanFalse(function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has double values', function (done) {
        testClient.queries.doubleDecimalNegative(function (error, result) {
          should.not.exist(error);
          testClient.queries.doubleDecimalPositive(function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has float values', function (done) {
        testClient.queries.floatScientificNegative(function (error, result) {
          should.not.exist(error);
          testClient.queries.floatScientificPositive(function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has int values', function (done) {
        testClient.queries.getIntNegativeOneMillion(function (error, result) {
          should.not.exist(error);
          testClient.queries.getIntOneMillion(function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has billion values', function (done) {
        testClient.queries.getNegativeTenBillion(function (error, result) {
          should.not.exist(error);
          testClient.queries.getTenBillion(function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has string values', function (done) {
        testClient.queries.stringEmpty(function (error, result) {
          should.not.exist(error);
          testClient.queries.stringUrlEncoded(function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has datetime', function (done) {
        testClient.queries.dateTimeValid(function (error, result) {
          should.not.exist(error);
          done();
        });
      });
      it('should work when query has byte values', function (done) {
        testClient.queries.byteEmpty(function (error, result) {
          should.not.exist(error);
          testClient.queries.byteMultiByte({ byteQuery: new Buffer('啊齄丂狛狜隣郎隣兀﨩') }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should work when query has enum values', function (done) {
        testClient.queries.enumValid({ enumQuery: '' }, function (error, result) {
          should.exist(error);
          testClient.queries.enumNull({ enumQuery: null }, function (error, result) {
            should.not.exist(error);
            testClient.queries.enumValid({ enumQuery: 'green color' }, function (error, result) {
              should.not.exist(error);
              done();
            });
          });
        });
      });
      it('should work when query has string array values', function (done) {
        var testArray = ['ArrayQuery1', 'begin!*\'();:@ &=+$,/?#[]end', null, ''];
        testClient.queries.arrayStringCsvEmpty({ arrayQuery: [] }, function (error, result) {
          should.not.exist(error);
          testClient.queries.arrayStringCsvValid({ arrayQuery: testArray }, function (error, result) {
            should.not.exist(error);
            testClient.queries.arrayStringPipesValid({ arrayQuery: testArray }, function (error, result) {
              should.not.exist(error);
              testClient.queries.arrayStringSsvValid({ arrayQuery: testArray }, function (error, result) {
                should.not.exist(error);
                testClient.queries.arrayStringTsvValid({ arrayQuery: testArray }, function (error, result) {
                  should.not.exist(error);
                  done();
                });
              });
            });
          });
        });
      });
      it('should work when path has string array values', function (done) {
        var testArray = ['ArrayPath1', 'begin!*\'();:@ &=+$,/?#[]end', null, ''];
        testClient.paths.arrayCsvInPath(testArray, function (error, result) {
          should.not.exist(error);
          done();
        });
      });
      it('should work when use null values in url query', function (done) {
        testClient.queries.byteNull({ byteQuery: null }, function (error, result) {
          should.not.exist(error);
          testClient.queries.dateNull({ dateQuery: null }, function (error, result) {
            should.not.exist(error);
            testClient.queries.dateTimeNull({ dateTimeQuery: null }, function (error, result) {
              should.not.exist(error);
              testClient.queries.doubleNull({ doubleQuery: null }, function (error, result) {
                should.not.exist(error);
                testClient.queries.floatNull({ floatQuery: null }, function (error, result) {
                  should.not.exist(error);
                  testClient.queries.getBooleanNull({ boolQuery: null }, function (error, result) {
                    should.not.exist(error);
                    testClient.queries.getIntNull({ intQuery: null }, function (error, result) {
                      should.not.exist(error);
                      testClient.queries.getLongNull({ longQuery: null }, function (error, result) {
                        should.not.exist(error);
                        testClient.queries.stringNull({ stringQuery: null }, function (error, result) {
                          should.not.exist(error);
                          testClient.queries.arrayStringCsvNull({ arrayQuery: null }, function (error, result) {
                            should.not.exist(error);
                            done();
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
    describe('Http infrastructure Client', function () {
      var testOptions = clientOptions;
      testOptions.requestOptions = { jar: true };
      testOptions.filters = [new msRest.ExponentialRetryPolicyFilter(3, 0, 0, 0)];
      testOptions.noRetryPolicy = true;
      var testClient = new httpClient(baseUri, testOptions);
      it('should work for all http success status codes with different verbs', function (done) {
        testClient.httpSuccess.head200(function (error, result) {
          should.not.exist(error);
          testClient.httpSuccess.get200(function (error, result) {
            should.not.exist(error);
            testClient.httpSuccess.put200(true, function (error, result) {
              should.not.exist(error);
              testClient.httpSuccess.post200(true, function (error, result) {
                should.not.exist(error);
                testClient.httpSuccess.patch200(true, function (error, result) {
                  should.not.exist(error);
                  testClient.httpSuccess.delete200(true, function (error, result) {
                    should.not.exist(error);
                    testClient.httpSuccess.put201(true, function (error, result) {
                      should.not.exist(error);
                      testClient.httpSuccess.post201(true, function (error, result) {
                        should.not.exist(error);
                        testClient.httpSuccess.put202(true, function (error, result) {
                          should.not.exist(error);
                          testClient.httpSuccess.post202(true, function (error, result) {
                            should.not.exist(error);
                            testClient.httpSuccess.patch202(true, function (error, result) {
                              should.not.exist(error);
                              testClient.httpSuccess.delete202(true, function (error, result) {
                                should.not.exist(error);
                                testClient.httpSuccess.head204(function (error, result) {
                                  should.not.exist(error);
                                  testClient.httpSuccess.put204(true, function (error, result) {
                                    should.not.exist(error);
                                    testClient.httpSuccess.post204(true, function (error, result) {
                                      should.not.exist(error);
                                      testClient.httpSuccess.delete204(true, function (error, result) {
                                        should.not.exist(error);
                                        testClient.httpSuccess.patch204(true, function (error, result) {
                                          should.not.exist(error);
                                          testClient.httpSuccess.head404(function (error, result) {
                                            should.not.exist(error);
                                            done();
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
      it('should work for all http redirect status codes with different verbs', function (done) {
        testClient.httpRedirects.head300(function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.httpRedirects.get300(function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.httpRedirects.head301(function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              testClient.httpRedirects.get301(function (error, result, request, response) {
                should.not.exist(error);
                response.statusCode.should.equal(200);
                testClient.httpRedirects.put301(true, function (error, result, request, response) {
                  should.not.exist(error);
                  response.statusCode.should.equal(301);
                  testClient.httpRedirects.head302(function (error, result, request, response) {
                    should.not.exist(error);
                    response.statusCode.should.equal(200);
                    testClient.httpRedirects.get302(function (error, result, request, response) {
                      should.not.exist(error);
                      response.statusCode.should.equal(200);
                      testClient.httpRedirects.patch302(true, function (error, result, request, response) {
                        should.not.exist(error);
                        response.statusCode.should.equal(302);
                        testClient.httpRedirects.post303(true, function (error, result, request, response) {
                          should.not.exist(error);
                          response.statusCode.should.equal(200);
                          testClient.httpRedirects.head307(function (error, result, request, response) {
                            should.not.exist(error);
                            response.statusCode.should.equal(200);
                            testClient.httpRedirects.get307(function (error, result, request, response) {
                              should.not.exist(error);
                              response.statusCode.should.equal(200);
                              //TODO, 4042586: Support options operations in swagger modeler
                              //testClient.httpRedirects.options307(function (error, result, request, response) {
                              //  should.not.exist(error);
                              testClient.httpRedirects.put307(true, function (error, result, request, response) {
                                should.not.exist(error);
                                response.statusCode.should.equal(200);
                                testClient.httpRedirects.post307(true, function (error, result, request, response) {
                                  should.not.exist(error);
                                  response.statusCode.should.equal(200);
                                  testClient.httpRedirects.patch307(true, function (error, result, request, response) {
                                    should.not.exist(error);
                                    response.statusCode.should.equal(200);
                                    testClient.httpRedirects.delete307(true, function (error, result, request, response) {
                                      should.not.exist(error);
                                      response.statusCode.should.equal(200);
                                      done();
                                    });
                                  });
                                });
                              });
                            });
                            //});
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });

      it('should work for all client failure status codes (4xx) with different verbs', function (done) {
        testClient.httpClientFailure.head400(function (error, result) {
          should.exist(error);
          (<msRest.ServiceError> error).statusCode.should.equal(400);
          testClient.httpClientFailure.get400(function (error, result) {
            should.exist(error);
            (<msRest.ServiceError> error).statusCode.should.equal(400);
            testClient.httpClientFailure.put400(true, function (error, result) {
              should.exist(error);
              (<msRest.ServiceError> error).statusCode.should.equal(400);
              testClient.httpClientFailure.patch400(true, function (error, result) {
                should.exist(error);
                (<msRest.ServiceError> error).statusCode.should.equal(400);
                testClient.httpClientFailure.post400(true, function (error, result) {
                  should.exist(error);
                  (<msRest.ServiceError> error).statusCode.should.equal(400);
                  testClient.httpClientFailure.delete400(true, function (error, result) {
                    should.exist(error);
                    (<msRest.ServiceError> error).statusCode.should.equal(400);
                    testClient.httpClientFailure.head401(function (error, result) {
                      should.exist(error);
                      (<msRest.ServiceError> error).statusCode.should.equal(401);
                      testClient.httpClientFailure.get402(function (error, result) {
                        should.exist(error);
                        (<msRest.ServiceError> error).statusCode.should.equal(402);
                        testClient.httpClientFailure.get403(function (error, result) {
                          should.exist(error);
                          (<msRest.ServiceError> error).statusCode.should.equal(403);
                          testClient.httpClientFailure.put404(true, function (error, result) {
                            should.exist(error);
                            (<msRest.ServiceError> error).statusCode.should.equal(404);
                            testClient.httpClientFailure.patch405(true, function (error, result) {
                              should.exist(error);
                              (<msRest.ServiceError> error).statusCode.should.equal(405);
                              testClient.httpClientFailure.post406(true, function (error, result) {
                                should.exist(error);
                                (<msRest.ServiceError> error).statusCode.should.equal(406);
                                testClient.httpClientFailure.delete407(true, function (error, result) {
                                  should.exist(error);
                                  (<msRest.ServiceError> error).statusCode.should.equal(407);
                                  testClient.httpClientFailure.put409(true, function (error, result) {
                                    should.exist(error);
                                    (<msRest.ServiceError> error).statusCode.should.equal(409);
                                    testClient.httpClientFailure.head410(function (error, result) {
                                      should.exist(error);
                                      (<msRest.ServiceError> error).statusCode.should.equal(410);
                                      testClient.httpClientFailure.get411(function (error, result) {
                                        should.exist(error);
                                        (<msRest.ServiceError> error).statusCode.should.equal(411);
                                        testClient.httpClientFailure.get412(function (error, result) {
                                          should.exist(error);
                                          (<msRest.ServiceError> error).statusCode.should.equal(412);
                                          testClient.httpClientFailure.put413(true, function (error, result) {
                                            should.exist(error);
                                            (<msRest.ServiceError> error).statusCode.should.equal(413);
                                            testClient.httpClientFailure.patch414(true, function (error, result) {
                                              should.exist(error);
                                              (<msRest.ServiceError> error).statusCode.should.equal(414);
                                              testClient.httpClientFailure.post415(true, function (error, result) {
                                                should.exist(error);
                                                (<msRest.ServiceError> error).statusCode.should.equal(415);
                                                testClient.httpClientFailure.get416(function (error, result) {
                                                  should.exist(error);
                                                  (<msRest.ServiceError> error).statusCode.should.equal(416);
                                                  testClient.httpClientFailure.delete417(true, function (error, result) {
                                                    should.exist(error);
                                                    (<msRest.ServiceError> error).statusCode.should.equal(417);
                                                    testClient.httpClientFailure.head429(function (error, result) {
                                                      should.exist(error);
                                                      (<msRest.ServiceError> error).statusCode.should.equal(429);
                                                        testClient.httpFailure.getEmptyError(function(error, result) {
                                                          should.exist(error);
                                                          (<msRest.ServiceError>error).statusCode.should.equal(400);
                                                          testClient.httpFailure.getNoModelError(function (error, result) {
                                                            should.exist(error);
                                                            (<msRest.ServiceError>error).statusCode.should.equal(400);
                                                                should.exist(error.message);
                                                                // TODO, 4213049: Better default error message
                                                                //error.message.should.match(/.*unexpected status code: 400.*/);
                                                                done();
                                                          });
                                                      });
                                                    });
                                                  });
                                                });
                                              });
                                            });
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });

      it('should work for all server failure status codes (5xx) with different verbs', function (done) {
        testClient.httpServerFailure.head501(function (error, result) {
          should.exist(error);
          (<msRest.ServiceError> error).statusCode.should.equal(501);
          testClient.httpServerFailure.get501(function (error, result) {
            should.exist(error);
            (<msRest.ServiceError> error).statusCode.should.equal(501);
            testClient.httpServerFailure.post505(true, function (error, result) {
              should.exist(error);
              (<msRest.ServiceError> error).statusCode.should.equal(505);
              testClient.httpServerFailure.delete505(true, function (error, result) {
                should.exist(error);
                (<msRest.ServiceError> error).statusCode.should.equal(505);
                done();
              });
            });
          });
        });
      });

      it('should properly perform the Http retry', function (done) {
        testClient.httpRetry.head408(function (error, result, request, response) {
          should.not.exist(error);
          response.statusCode.should.equal(200);
          testClient.httpRetry.get502(function (error, result, request, response) {
            should.not.exist(error);
            response.statusCode.should.equal(200);
            testClient.httpRetry.put500(true, function (error, result, request, response) {
              should.not.exist(error);
              response.statusCode.should.equal(200);
              testClient.httpRetry.patch500(true, function (error, result, request, response) {
                should.not.exist(error);
                response.statusCode.should.equal(200);
                testClient.httpRetry.post503(true, function (error, result, request, response) {
                  should.not.exist(error);
                  response.statusCode.should.equal(200);
                  testClient.httpRetry.delete503(true, function (error, result, request, response) {
                    should.not.exist(error);
                    response.statusCode.should.equal(200);
                    testClient.httpRetry.put504(true, function (error, result, request, response) {
                      should.not.exist(error);
                      response.statusCode.should.equal(200);
                      testClient.httpRetry.patch504(true, function (error, result, request, response) {
                        should.not.exist(error);
                        response.statusCode.should.equal(200);
                        done();
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });

      it('should properly handle multiple responses with different verbs', function (done) {
        testClient.multipleResponses.get200Model204NoModelDefaultError200Valid(function (error, result) {
          should.not.exist(error);
          result.statusCode.should.equal("200");
          //should use models.Error to deserialize and set it as body of javascript Error object
          testClient.multipleResponses.get200Model204NoModelDefaultError201Invalid(function (error, result) {
            should.exist(error);
            (<msRest.ServiceError> error).statusCode.should.equal(201);
            testClient.multipleResponses.get200Model204NoModelDefaultError202None(function (error, result) {
              should.exist(error);
              (<msRest.ServiceError> error).statusCode.should.equal(202);
              //should we set body property of msRest.HttpOperationResponse to {}.
              //C3 does this Assert.Null(client.MultipleResponses.Get200Model204NoModelDefaultError204Valid());
              testClient.multipleResponses.get200Model204NoModelDefaultError204Valid(function (error, result) {
                should.not.exist(error);
                should.not.exist(result);
                //{"message":"client error","status":400} shouldn't we set this to error model defined in swagger?
                testClient.multipleResponses.get200Model204NoModelDefaultError400Valid(function (error, result) {
                  should.exist(error);
                  (<msRest.ServiceError> error).statusCode.should.equal(400);
                  testClient.multipleResponses.get200Model201ModelDefaultError200Valid(function (error, result) {
                    should.not.exist(error);
                    result.statusCode.should.equal("200");
                    testClient.multipleResponses.get200Model201ModelDefaultError201Valid(function (error, result) {
                      should.not.exist(error);
                      should.exist(result);
                      assert.deepEqual(result, { 'statusCode': '201', 'textStatusCode': 'Created' });
                      testClient.multipleResponses.get200Model201ModelDefaultError400Valid(function (error, result) {
                        should.exist(error);
                        (<msRest.ServiceError> error).statusCode.should.equal(400);
                        testClient.multipleResponses.get200ModelA201ModelC404ModelDDefaultError200Valid(function (error, result) {
                          should.not.exist(error);
                          should.exist(result);
                          result.statusCode.should.equal("200");
                          testClient.multipleResponses.get200ModelA201ModelC404ModelDDefaultError201Valid(function (error, result) {
                            should.not.exist(error);
                            should.exist(result);
                            result.httpCode.should.equal("201");
                            testClient.multipleResponses.get200ModelA201ModelC404ModelDDefaultError404Valid(function (error, result) {
                              should.not.exist(error);
                              should.exist(result);
                              result.httpStatusCode.should.equal("404");
                              testClient.multipleResponses.get200ModelA201ModelC404ModelDDefaultError400Valid(function (error, result) {
                                should.exist(error);
                                (<msRest.ServiceError> error).statusCode.should.equal(400);
                                testClient.multipleResponses.get202None204NoneDefaultError202None(function (error, result) {
                                  should.not.exist(error);
                                  testClient.multipleResponses.get202None204NoneDefaultError204None(function (error, result) {
                                    should.not.exist(error);
                                    testClient.multipleResponses.get202None204NoneDefaultError400Valid(function (error, result) {
                                      should.exist(error);
                                      (<msRest.ServiceError> error).statusCode.should.equal(400);
                                      testClient.multipleResponses.get202None204NoneDefaultNone202Invalid(function (error, result) {
                                        should.not.exist(error);
                                        testClient.multipleResponses.get202None204NoneDefaultNone204None(function (error, result) {
                                          should.not.exist(error);
                                          testClient.multipleResponses.get202None204NoneDefaultNone400None(function (error, result) {
                                            should.exist(error);
                                            (<msRest.ServiceError> error).statusCode.should.equal(400);
                                            testClient.multipleResponses.get202None204NoneDefaultNone400Invalid(function (error, result) {
                                              should.exist(error);
                                              (<msRest.ServiceError> error).statusCode.should.equal(400);
                                              testClient.multipleResponses.getDefaultModelA200Valid(function (error, result) {
                                                should.not.exist(error);
                                                //result.statusCode.should.equal("200");
                                                testClient.multipleResponses.getDefaultModelA200None(function (error, result) {
                                                  should.not.exist(error);
                                                  testClient.multipleResponses.getDefaultModelA400Valid(function (error, result) {
                                                    should.exist(error);
                                                    (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                    testClient.multipleResponses.getDefaultModelA400None(function (error, result) {
                                                      should.exist(error);
                                                      (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                      testClient.multipleResponses.getDefaultNone200Invalid(function (error, result) {
                                                        should.not.exist(error);
                                                        testClient.multipleResponses.getDefaultNone200None(function (error, result) {
                                                          should.not.exist(error);
                                                          testClient.multipleResponses.getDefaultNone400Invalid(function (error, result) {
                                                            should.exist(error);
                                                            (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                            testClient.multipleResponses.getDefaultNone400None(function (error, result) {
                                                              should.exist(error);
                                                              (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                              testClient.multipleResponses.get200ModelA200None(function (error, result) {
                                                                should.not.exist(error);
                                                                testClient.multipleResponses.get200ModelA200Valid(function (error, result) {
                                                                  should.not.exist(error);
                                                                  result.statusCode.should.equal("200");
                                                                  testClient.multipleResponses.get200ModelA200Invalid(function (error, result) {
                                                                    should.not.exist(error);
                                                                    testClient.multipleResponses.get200ModelA400None(function (error, result) {
                                                                      should.exist(error);
                                                                      (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                                      testClient.multipleResponses.get200ModelA400Valid(function (error, result) {
                                                                        should.exist(error);
                                                                        (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                                        testClient.multipleResponses.get200ModelA400Invalid(function (error, result) {
                                                                          should.exist(error);
                                                                          (<msRest.ServiceError> error).statusCode.should.equal(400);
                                                                          testClient.multipleResponses.get200ModelA202Valid(function (error, result) {
                                                                            should.exist(error);
                                                                            (<msRest.ServiceError> error).statusCode.should.equal(202);
                                                                            done();
                                                                          });
                                                                        });
                                                                      });
                                                                    });
                                                                  });
                                                                });
                                                              });
                                                            });
                                                          });
                                                        });
                                                      });
                                                    });
                                                  });
                                                });
                                              });
                                            });
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });
});
