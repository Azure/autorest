// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var should = require('should');
var http = require('http');
var util = require('util');
var assert = require('assert');
var msRest = require('ms-rest');

var complexClient = require('../Expected/AcceptanceTests/BodyComplex/autoRestComplexTestService');

var dummyToken = 'dummy12321343423';
var credentials = new msRest.TokenCredentials(dummyToken);

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger Complex Type BAT', function () {

    describe('Basic Types Operations', function () {
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get and put valid basic type properties', function (done) {
        testClient.basicOperations.getValid(function (error, result) {
          should.not.exist(error);
          result.body.id.should.equal(2);
          result.body.name.should.equal('abc');
          result.body.color.should.equal('YELLOW');
          testClient.basicOperations.putValid({ 'id': 2, 'name': 'abc', color: 'Magenta' }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should handle invalid enum value in a complex type', function (done) {
        testClient.basicOperations.putValid({ 'id': 2, 'name': 'abc', color: 'Blue' }, function (error, result) {
          should.exist(error);
          error.message.should.match(/.*is not a valid value.*/ig);
          done();
        });
      });

      it('should get null basic type properties', function (done) {
        testClient.basicOperations.getNull(function (error, result) {
          should.not.exist(error);
          assert.equal(null, result.body.id);
          assert.equal(null, result.body.name);
          done();
        });
      });

      it('should get empty basic type properties', function (done) {
        testClient.basicOperations.getEmpty(function (error, result) {
          should.not.exist(error);
          should.not.exist(result.body.id);
          should.not.exist(result.body.name);
          done();
        });
      });

      it('should get basic type properties when the payload is empty', function (done) {
        testClient.basicOperations.getNotProvided(function (error, result) {
          should.not.exist(error);
          should.not.exist(result.body);
          done();
        });
      });

      it('should deserialize invalid basic types without throwing', function (done) {
        testClient.basicOperations.getInvalid(function (error, result) {
          should.not.exist(error);
          should.exist(result.body);
          done();
        });
      });

    });

    describe('Primitive Types Operations', function () {
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get and put valid int properties', function (done) {
        testClient.primitive.getInt(function (error, result) {
          should.not.exist(error);
          result.body.field1.should.equal(-1);
          result.body.field2.should.equal(2);
          testClient.primitive.putInt({ 'field1': -1, 'field2': 2 }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put valid long properties', function (done) {
        testClient.primitive.getLong(function (error, result) {
          should.not.exist(error);
          result.body.field1.should.equal(1099511627775);
          result.body.field2.should.equal(-999511627788);
          testClient.primitive.putLong({ 'field1': 1099511627775, 'field2': -999511627788 }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put valid float properties', function (done) {
        testClient.primitive.getFloat(function (error, result) {
          should.not.exist(error);
          result.body.field1.should.equal(1.05);
          result.body.field2.should.equal(-0.003);
          testClient.primitive.putFloat({ 'field1': 1.05, 'field2': -0.003 }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put valid double properties', function (done) {
        testClient.primitive.getDouble(function (error, result) {
          should.not.exist(error);
          result.body.field1.should.equal(3e-100);
          result.body.field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose.should.equal(-0.000000000000000000000000000000000000000000000000000000005);
          testClient.primitive.putDouble({ 'field1': 3e-100, 'field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose': -0.000000000000000000000000000000000000000000000000000000005 }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put valid bool properties', function (done) {
        testClient.primitive.getBool(function (error, result) {
          should.not.exist(error);
          result.body.field_true.should.equal(true);
          result.body.field_false.should.equal(false);
          testClient.primitive.putBool({ 'field_true': true, 'field_false': false }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put valid string properties', function (done) {
        testClient.primitive.getString(function (error, result) {
          should.not.exist(error);
          result.body.field.should.equal('goodrequest');
          result.body.empty.should.equal('');
          should.not.exist(result.body['null']);
          testClient.primitive.putString({ 'field': 'goodrequest', 'empty': '' }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put valid date properties', function (done) {
        testClient.primitive.getDate(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.field, new Date('0001-01-01'));
          assert.deepEqual(result.body.leap, new Date('2016-02-29'));
          //testClient.primitive.putDate({ 'field': 'goodrequest', 'empty': '' }, function (error, result) {
          //  should.not.exist(error);
          done();
          //});
        });
      });
      it('should get and put valid date-time properties', function (done) {
        testClient.primitive.getDateTime(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.field, new Date('0001-01-01T00:00:00Z'));
          assert.deepEqual(result.body.now, new Date('2015-05-18T18:38:00Z'));
          testClient.primitive.putDateTime({ 'field': new Date('0001-01-01T00:00:00Z'), 'now': new Date('2015-05-18T18:38:00Z') }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      it('should get and put valid byte properties', function (done) {
        var byteBuffer = new Buffer([255, 254, 253, 252, 0, 250, 249, 248, 247, 246]);
        testClient.primitive.getByte(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.field, byteBuffer);
          testClient.primitive.putByte({ 'field': byteBuffer }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

    });

    describe('Array Types Operations', function () {
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get valid array type properties', function (done) {
        var testArray = ['1, 2, 3, 4', '', null, '&S#$(*Y', 'The quick brown fox jumps over the lazy dog'];
        testClient.arrayModel.getValid(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.array, testArray);
          testClient.arrayModel.putValid({ 'array': testArray }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });


      it('should get and put empty array type properties', function (done) {
        testClient.arrayModel.getEmpty(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.array, []);
          testClient.arrayModel.putEmpty({ 'array': [] }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get array type properties when the payload is empty', function (done) {
        testClient.arrayModel.getNotProvided(function (error, result) {
          should.not.exist(error);
          should.not.exist(result.body.array);
          done();
        });
      });

    });

    describe('Dictionary Types Operations', function () {
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get valid dictionary type properties', function (done) {
        var testDictionary = { 'txt': 'notepad', 'bmp': 'mspaint', 'xls': 'excel', 'exe': '', '': null };
        testClient.dictionary.getValid(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.defaultProgram, testDictionary);
          testClient.dictionary.putValid({ 'defaultProgram': testDictionary }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get and put empty dictionary type properties', function (done) {
        testClient.dictionary.getEmpty(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body.defaultProgram, {});
          testClient.dictionary.putEmpty({ 'defaultProgram': {} }, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

      it('should get null dictionary type properties', function (done) {
        testClient.dictionary.getNull(function (error, result) {
          should.not.exist(error);
          should.not.exist(result.body.defaultProgram);
          done();
        });
      });

      it('should get dictionary type properties when the payload is empty', function (done) {
        testClient.dictionary.getNotProvided(function (error, result) {
          should.not.exist(error);
          should.not.exist(result.body.defaultProgram);
          done();
        });
      });

    });

    describe('Complex Types with Inheritance Operations', function () {
      var siamese = { "breed": "persian", "color": "green", "hates": [{ "food": "tomato", "id": 1, "name": "Potato" }, { "food": "french fries", "id": -1, "name": "Tomato" }], "id": 2, "name": "Siameeee" };
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get valid basic type properties', function (done) {
        testClient.inheritance.getValid(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body, siamese);
          testClient.inheritance.putValid(siamese, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });

    });

    describe('Complex Types with Polymorphism Operations', function () {
      var fish = {
        'dtype': 'salmon',
        'location': 'alaska',
        'iswild': true,
        'species': 'king',
        'length': 1.0,
        'siblings': [
          {
            'dtype': 'shark',
            'age': 6,
            'birthday': new Date('2012-01-05T01:00:00Z'),
            'length': 20.0,
            'species': 'predator'
          },
          {
            'dtype': 'sawshark',
            'age': 105,
            'birthday': new Date('1900-01-05T01:00:00Z'),
            'length': 10.0,
            'picture': new Buffer([255, 255, 255, 255, 254]),
            'species': 'dangerous'
          }
        ]
      };
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get valid polymorphic properties', function (done) {
        testClient.polymorphism.getValid(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body, fish);
          testClient.polymorphism.putValid(fish, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
      var badfish = {
        'dtype': 'sawshark',
        'species': 'snaggle toothed',
        'length': 18.5,
        'age': 2,
        'birthday': new Date('2013-06-01T01:00:00Z'),
        'location': 'alaska',
        'picture': new Buffer([255, 255, 255, 255, 254]),
        'siblings': [
          {
            'dtype': 'shark',
            'species': 'predator',
            'birthday': new Date('2012-01-05T01:00:00Z'),
            'length': 20,
            'age': 6
          },
          {
            'dtype': 'sawshark',
            'species': 'dangerous',
            'picture': new Buffer([255, 255, 255, 255, 254]),
            'length': 10,
            'age': 105
          }
        ]
      };
      it('should throw when required fields are omitted from polymorphic types', function (done) {
        testClient.polymorphism.putValidMissingRequired(badfish, function (error, result) {
          should.exist(error);
          error.message.should.containEql('birthday');
          error.message.should.containEql('cannot be null or undefined');
          done();
        });
      });
    });

    describe('Complex Types with recursive definitions', function () {
      var bigfish = {
        'dtype': 'salmon',
        'location': 'alaska',
        'iswild': true,
        'species': 'king',
        'length': 1,
        'siblings': [
          {
            'dtype': 'shark',
            'age': 6,
            'birthday': new Date('2012-01-05T01:00:00Z'),
            'species': 'predator',
            'length': 20,
            'siblings': [
              {
                'dtype': 'salmon',
                'location': 'atlantic',
                'iswild': true,
                'species': 'coho',
                'length': 2,
                'siblings': [
                  {
                    'dtype': 'shark',
                    'age': 6,
                    'birthday': new Date('2012-01-05T01:00:00Z'),
                    'species': 'predator',
                    'length': 20
                  },
                  {
                    'dtype': 'sawshark',
                    'age': 105,
                    'birthday': new Date('1900-01-05T01:00:00Z'),
                    'picture': new Buffer([255, 255, 255, 255, 254]),
                    'species': 'dangerous',
                    'length': 10
                  }
                ]
              },
              {
                'dtype': 'sawshark',
                'age': 105,
                'birthday': new Date('1900-01-05T01:00:00Z'),
                'picture': new Buffer([255, 255, 255, 255, 254]),
                'species': 'dangerous',
                'length': 10,
                'siblings': []
              }
            ]
          },
          {
            'dtype': 'sawshark',
            'age': 105,
            'birthday': new Date('1900-01-05T01:00:00Z'),
            'picture': new Buffer([255, 255, 255, 255, 254]),
            'species': 'dangerous',
            'length': 10,
            'siblings': []
          }
        ]
      };
      var testClient = new complexClient(baseUri, clientOptions);
      it('should get and put valid basic type properties', function (done) {
        testClient.polymorphicrecursive.getValid(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result.body, bigfish);
          testClient.polymorphicrecursive.putValid(bigfish, function (error, result) {
            should.not.exist(error);
            done();
          });
        });
      });
    });
  });
});
