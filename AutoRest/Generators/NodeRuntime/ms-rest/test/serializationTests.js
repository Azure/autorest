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

  describe('deserializeDate', function () {
    it('should correctly deserialize max local positive offset \'9999-12-31T23:59:59+23:59\' value', function (done) {
      var date = msRest.deserializeDate('9999-12-31T23:59:59+23:59');
      date.getUTCFullYear().should.equal(9999);
      date.getUTCMonth().should.equal(11);
      date.getUTCDate().should.equal(31);
      date.getUTCHours().should.equal(0);
      date.getUTCMinutes().should.equal(0);
      date.getUTCSeconds().should.equal(59);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });

    it('should correctly max local negative offset deserialize \'9999-12-31T23:59:59-23:59\' value', function (done) {
      var date = msRest.deserializeDate('9999-12-31T23:59:59-23:59');
      date.getUTCFullYear().should.equal(10000);
      date.getUTCMonth().should.equal(0);
      date.getUTCDate().should.equal(1);
      date.getUTCHours().should.equal(23);
      date.getUTCMinutes().should.equal(58);
      date.getUTCSeconds().should.equal(59);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });
    
    it('should correctly deserialize min local negative offset \'0000-01-01T00:00:00-23:59\' value', function (done) {
      var date = msRest.deserializeDate('0000-01-01T00:00:00-23:59');
      date.getUTCFullYear().should.equal(0);
      date.getUTCMonth().should.equal(0);
      date.getUTCDate().should.equal(1);
      date.getUTCHours().should.equal(23);
      date.getUTCMinutes().should.equal(59);
      date.getUTCSeconds().should.equal(0);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });
    
    it('should correctly deserialize min local positive offset \'0000-01-01T00:00:00+23:59\' value', function (done) {
      var date = msRest.deserializeDate('0000-01-01T00:00:00+23:59');
      date.getUTCFullYear().should.equal(-1);
      date.getUTCMonth().should.equal(11);
      date.getUTCDate().should.equal(31);
      date.getUTCHours().should.equal(0);
      date.getUTCMinutes().should.equal(1);
      date.getUTCSeconds().should.equal(0);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });
    
    it('should correctly deserialize max UTC \'9999-12-31T23:59:59.9999999Z\' value', function (done) {
      var date = msRest.deserializeDate('9999-12-31T23:59:59.9999999Z');
      date.getUTCFullYear().should.equal(9999);
      date.getUTCMonth().should.equal(11);
      date.getUTCDate().should.equal(31);
      date.getUTCHours().should.equal(23);
      date.getUTCMinutes().should.equal(59);
      date.getUTCSeconds().should.equal(59);
      date.getUTCMilliseconds().should.equal(999);
      done();
    });
    
    it('should correctly deserialize min UTC \'0001-01-01T00:00:00Z\' value', function (done) {
      var date = msRest.deserializeDate('0001-01-01T00:00:00Z');
      date.getUTCFullYear().should.equal(1);
      date.getUTCMonth().should.equal(0);
      date.getUTCDate().should.equal(1);
      date.getUTCHours().should.equal(0);
      date.getUTCMinutes().should.equal(0);
      date.getUTCSeconds().should.equal(0);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });
    
    it('should deserialize \'2010-06-31T00:00:00Z\' to \'2010-07-01T00:00:00Z\' as month of \'June\' has only \'30\' days', function (done) {
      var date = msRest.deserializeDate('2010-06-31T00:00:00Z');
      date.getUTCFullYear().should.equal(2010);
      date.getUTCMonth().should.equal(6);
      date.getUTCDate().should.equal(1);
      date.getUTCHours().should.equal(0);
      date.getUTCMinutes().should.equal(0);
      date.getUTCSeconds().should.equal(0);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });

    it('should correctly deserialize min date \'0000-01-01\' value', function (done) {
      var date = msRest.deserializeDate('0000-01-01');
      date.getUTCFullYear().should.equal(0);
      date.getUTCMonth().should.equal(0);
      date.getUTCDate().should.equal(1);
      date.getUTCHours().should.equal(0);
      date.getUTCMinutes().should.equal(0);
      date.getUTCSeconds().should.equal(0);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });
    
    it('should correctly deserialize max date \'9999-12-31\' value', function (done) {
      var date = msRest.deserializeDate('9999-12-31');
      date.getUTCFullYear().should.equal(9999);
      date.getUTCMonth().should.equal(11);
      date.getUTCDate().should.equal(31);
      date.getUTCHours().should.equal(0);
      date.getUTCMinutes().should.equal(0);
      date.getUTCSeconds().should.equal(0);
      date.getUTCMilliseconds().should.equal(0);
      done();
    });

    it('should throw an error for null value', function (done) {
      msRest.deserializeDate.bind(null, null).should.throw();
      done();
    });
    
    it('should throw an error for value \'Happy New Year 2016\'', function (done) {
      msRest.deserializeDate.bind(null, 'Happy New Year 2016').should.throw();
      done();
    });

    it('should throw an error for undefined value', function (done) {
      msRest.deserializeDate.bind(null, undefined).should.throw();
      done();
    });

    it('should throw an error for 2010 value', function (done) {
      msRest.deserializeDate.bind(null, 2010).should.throw();
      done();
    });

    it('should throw an error for true value', function (done) {
      msRest.deserializeDate.bind(null, true).should.throw();
      done();
    });

    it('should throw an error for \'99999-12-31\' value', function (done) {
      msRest.deserializeDate.bind(null, '99999-12-31').should.throw();
      done();
    });

    it('should throw an error for \'2010-13-31\' value', function (done) {
      msRest.deserializeDate.bind(null, '2010-13-31').should.throw();
      done();
    });

    it('should throw an error for \'2015-22-01\' value', function (done) {
      msRest.deserializeDate.bind(null, '2015-22-01').should.throw();
      done();
    });

    it('should throw an error for \'2015-02-32\' value', function (done) {
      msRest.deserializeDate.bind(null, '2015-02-32').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01F01:01:01+00:30\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01F01:01:01+00:30').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01t01:01:01/00:30\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01t01:01:01/00:30').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01T24:01:01+00:30\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01T24:01:01+00:30').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01T23:60:01+00:30\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01T23:60:01+00:30').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01T23:01:78+00:30\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01T23:01:78+00:30').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01T23:01:54-24:30\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01T23:01:54-24:30').should.throw();
      done();
    });

    it('should throw an error for \'1996-01-01T23:01:54-22:66\' value', function (done) {
      msRest.deserializeDate.bind(null, '1996-01-01T23:01:54-22:66').should.throw();
      done();
    });

  });
});