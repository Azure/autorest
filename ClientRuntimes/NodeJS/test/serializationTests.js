// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');

var msRest = require('../lib/msRest');

describe('msrest', function () {
  describe('serializeObject', function () {
    it('should correctly serialize a Date Object', function (done) {
      var dateObj = new Date('2015-01-01');
      var dateISO = '2015-01-01T00:00:00.000Z';
      msRest.serializeObject(dateObj).should.equal(dateISO);
      done();
    });
    
    it('should correctly serialize a Date object with max value', function (done) {
      var serializedDateString = msRest.serializeObject(new Date('9999-12-31T23:59:59-12:00'));
      serializedDateString.should.equal('+010000-01-01T11:59:59.000Z');
      done();
    });
    
    it('should correctly serialize a Buffer Object', function (done) {
      var bufferObj = new Buffer('Javascript');
      var base64str = 'SmF2YXNjcmlwdA==';
      msRest.serializeObject(bufferObj).should.equal(base64str);
      done();
    });
    
    it('should correctly serialize Primitive types', function (done) {
      msRest.serializeObject(true).should.equal(true);
      msRest.serializeObject(false).should.equal(false);
      msRest.serializeObject('true').should.equal('true');
      msRest.serializeObject(1).should.equal(1);
      msRest.serializeObject(100.0123).should.equal(100.0123);
      assert.equal(msRest.serializeObject(null), null);
      done();
    });
    
    it('should correctly serialize an empty array and an empty dictionary', function (done) {
      assert.deepEqual(msRest.serializeObject([]), []);
      assert.deepEqual(msRest.serializeObject({}), {});
      done();
    });
    
    it('should correctly serialize a complex JSON object', function (done) {
      var o1 = {
        'p1' : 'value1',
        'p2' : 'value2',
        'top-buf' : new Buffer('top string', 'utf-8'),
        'top-date': new Date('2014'),
        'top-dates' : [new Date('1900'), new Date('1901')],
        'insider' : {
          'insider-buf' : new Buffer('insider string', 'utf-8'),
          'insider-date' : new Date('2015'),
          'insider-dates' : [new Date('2100'), new Date('2101')],
          'insider-dictionary' : {
            'k1': new Date('2015'),
            'k2': new Date('2016'),
            'k3': new Date('2017')
          },
          'top-complex': {
            'id': 1,
            'name': 'Joey',
            'age': 23.36,
            'male': true,
            'birthday': '1992-01-01T00:00:00.000Z',
            'anniversary': new Date('2013-12-08'),
            'memory' : new Buffer('Yadadadada')
          }
        }
      };
      
      var o2 = {
        p1: 'value1',
        p2: 'value2',
        'top-buf': 'dG9wIHN0cmluZw==',
        'top-date': '2014-01-01T00:00:00.000Z',
        'top-dates': [
          '1900-01-01T00:00:00.000Z',
          '1901-01-01T00:00:00.000Z'
        ],
        insider: {
          'insider-buf': 'aW5zaWRlciBzdHJpbmc=',
          'insider-date': '2015-01-01T00:00:00.000Z',
          'insider-dates': [
            '2100-01-01T00:00:00.000Z',
            '2101-01-01T00:00:00.000Z'
          ],
          'insider-dictionary': {
            k1: '2015-01-01T00:00:00.000Z',
            k2: '2016-01-01T00:00:00.000Z',
            k3: '2017-01-01T00:00:00.000Z'
          },
          'top-complex': {
            id: 1,
            name: 'Joey',
            age: 23.36,
            male: true,
            birthday: '1992-01-01T00:00:00.000Z',
            anniversary: '2013-12-08T00:00:00.000Z',
            memory: 'WWFkYWRhZGFkYQ=='
          }
        }
      };
      assert.deepEqual(msRest.serializeObject(o1), o2);
      done();
    });
  });
});