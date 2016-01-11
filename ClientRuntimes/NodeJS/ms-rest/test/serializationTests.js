// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var assert = require('assert');
var should = require('should');
var moment = require('moment');
var util = require('util');
var msRest = require('../lib/msRest');
var testClient = require('./data/TestClient/lib/testClient');

var tokenCredentials = new msRest.TokenCredentials('dummy');

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

  describe('serialize', function () {
    var mapper = {};
    it('should correctly serialize a string', function (done) {
      mapper = { type : { name: 'String' } };
      var serializedObject = msRest.serialize(mapper, 'foo', 'stringBody');
      serializedObject.should.equal('foo');
      done();
    });
    it('should correctly serialize a number', function (done) {
      mapper = { type : { name: 'Number' } };
      var serializedObject = msRest.serialize(mapper, 1.506, 'stringBody');
      serializedObject.should.equal(1.506);
      done();
    });
    it('should correctly serialize a boolean', function (done) {
      mapper = { type : { name: 'boolean' } };
      var serializedObject = msRest.serialize(mapper, false, 'stringBody');
      serializedObject.should.equal(false);
      done();
    });
    it('should correctly serialize an Enum', function (done) {
      mapper = { type : { name: 'Enum', allowedValues: [1, 2, 3, 4] } };
      var serializedObject = msRest.serialize(mapper, 1, 'enumBody');
      serializedObject.should.equal(1);
      done();
    });
    it('should throw an error if the value is not valid for an Enum', function (done) {
      mapper = { type : { name: 'Enum', allowedValues: [1, 2, 3, 4] } };
      try {
        var serializedObject = msRest.serialize(mapper, 6, 'enumBody');
      } catch (error) {
        error.message.should.match(/6 is not a valid value for enumBody\. The valid values are: \[1,2,3,4\]/ig);
        done();
      }
    });
    it('should throw an error if allowedValues is not specified for an EnumType', function (done) {
      mapper = { type : { name: 'Enum' } };
      try {
        var serializedObject = msRest.serialize(mapper, 6, 'enumBody');
      } catch (error) {
        error.message.should.match(/Please provide a set of allowedValues to validate enumBody as an Enum Type\./ig);
        done();
      }
    });
    it('should correctly serialize a Buffer Object', function (done) {
      mapper = { type : { name: 'ByteArray' } };
      var bufferObj = new Buffer('Javascript');
      var base64str = 'SmF2YXNjcmlwdA==';
      var serializedObject = msRest.serialize(mapper, bufferObj, 'stringBody');
      serializedObject.should.equal(base64str);
      done();
    });
    it('should correctly serialize a Date Object', function (done) {
      var dateObj = new Date('2015-01-01');
      var dateISO = '2015-01-01';
      mapper = { type : { name: 'Date' } };
      msRest.serialize(mapper, dateObj, 'dateObj').should.equal(dateISO);
      done();
    });
    it('should correctly serialize a Date object with max value', function (done) {
      mapper = { type : { name: 'DateTime' } };
      var serializedDateString = msRest.serialize(mapper, new Date('9999-12-31T23:59:59-12:00'), 'dateTimeObj');
      serializedDateString.should.equal('+010000-01-01T11:59:59.000Z');
      done();
    });
    it('should correctly serialize a string in DateTimeRfc1123', function (done) {
      mapper = { type : { name: 'DateTimeRfc1123' } };
      var rfc = new Date('Mon, 01 Jan 0001 00:00:00 GMT');
      var serializedDateString = msRest.serialize(mapper, rfc, 'dateTimeObj');
      serializedDateString.should.equal('Mon, 01 Jan 2001 00:00:00 GMT');
      done();
    });
    it('should correctly serialize a duration object', function (done) {
      mapper = { type : { name: 'TimeSpan' } };
      var duration = moment.duration({ days: 123, hours: 22, minutes: 14, seconds: 12, milliseconds: 11 });
      var serializedDateString = msRest.serialize(mapper, duration, 'dateTimeObj');
      serializedDateString.should.equal('P123DT22H14M12.010999999998603S');
      done();
    });
    
    it('should correctly serialize an array of primitives', function (done) {
      mapper = { type : { name: 'Sequence', element: { type : { name: 'String' } } } };
      var array = ['One', 'Two', 'three'];
      var serializedArray = msRest.serialize(mapper, array, 'arrayObj');
      assert.deepEqual(array, serializedArray);
      done();
    });
    
    it('should correctly serialize an array of array of primitives', function (done) {
      mapper = {
        type : {
          name: 'Sequence', 
          element: {
            type : {
              name: 'Sequence',
              element: {
                type: {
                  name: 'Number'
                }
              }
            }
          }
        }
      };
      var array = [[1], [2], [1, 2, 3]];
      var serializedArray = msRest.serialize(mapper, array, 'arrayObj');
      assert.deepEqual(array, serializedArray);
      done();
    });
    
    it('should correctly serialize an array of dictionary of primitives', function (done) {
      mapper = {
        type : {
          name: 'Sequence', 
          element: {
            type : {
              name: 'Dictionary',
              value: {
                type: {
                  name: 'Boolean'
                }
              }
            }
          }
        }
      };
      var array = [{ 1: true }, { 2: false }, { 1: true, 2: false, 3: true }];
      var serializedArray = msRest.serialize(mapper, array, 'arrayObj');
      assert.deepEqual(array, serializedArray);
      done();
    });
    
    it('should correctly serialize a dictionary of primitives', function (done) {
      mapper = { type : { name: 'Dictionary', value: { type : { name: 'String' } } } };
      var dict = { 1: 'One', 2: 'Two', 3: 'three' };
      var serializedDictionary = msRest.serialize(mapper, dict, 'dictObj');
      assert.deepEqual(dict, serializedDictionary);
      done();
    });
    
    it('should correctly serialize a dictionary of array of primitives', function (done) {
      mapper = {
        type : {
          name: 'Dictionary', 
          value: {
            type : {
              name: 'Sequence',
              element: {
                type: {
                  name: 'Number'
                }
              }
            }
          }
        }
      };
      var dict = { 'One': [1], 'Two': [1, 2], 'three': [1, 2, 3] };
      var serializedDictionary = msRest.serialize(mapper, dict, 'dictObj');
      assert.deepEqual(dict, serializedDictionary);
      done();
    });
    
    it('should correctly serialize a dictionary of dictionary of primitives', function (done) {
      mapper = {
        type : {
          name: 'Dictionary', 
          value: {
            type : {
              name: 'Dictionary',
              value: {
                type: {
                  name: 'Boolean'
                }
              }
            }
          }
        }
      };
      var dict = { 1: { 'One': true }, 2: { 'Two': false }, 3: { 'three': true } };
      var serializedDictionary = msRest.serialize(mapper, dict, 'dictObj');
      assert.deepEqual(dict, serializedDictionary);
      done();
    });

    it('should correctly serialize a composite type', function (done) {
      var client = new testClient('http://localhost:9090');
      var product = new client.models['Product']();
      mapper = product.mapper();
      var productObj = {
        id: 101,
        name: 'TestProduct',
        provisioningState: 'Succeeded',
        tags: {
          tag1: 'value1',
          tag2: 'value2'
        },
        dispatchTime: new Date('2015-01-01T12:35:36.009Z'),
        invoiceInfo: {
          invId: 1002,
          invDate: '2015-12-25',
          invProducts: [
            {
              'Product1' : {
                id: 101,
                name: 'TestProduct'
              }
            },
            {
              'Product2' : {
                id: 104,
                name: 'TestProduct1'
              }
            }
          ]
        },
        subProducts: [
          {
            subId: 102,
            subName: 'SubProduct1',
            makeTime: new Date('2015-12-21T01:01:01'),
            invoiceInfo: {
              invId: 1002,
              invDate: '2015-12-25'
            }
          },
          {
            subId: 103,
            subName: 'SubProduct2',
            makeTime: new Date('2015-12-21T01:01:01'),
            invoiceInfo: {
              invId: 1003,
              invDate: '2015-12-25'
            }
          }
        ]
      };
      var serializedProduct = client.serialize(mapper, productObj, 'productObject');
      for (var prop in serializedProduct) {
        if (prop === 'properties') {
          serializedProduct[prop].provisioningState.should.equal(productObj.provisioningState);
        } else if (prop === 'id') {
          serializedProduct[prop].should.equal(productObj.id);
        } else if (prop === 'name') {
          serializedProduct[prop].should.equal(productObj.name);
        } else if (prop === 'tags') {
          JSON.stringify(serializedProduct[prop]).should.equal(JSON.stringify(productObj.tags));
        } else if (prop === 'dispatchTime') {
          JSON.stringify(serializedProduct[prop]).should.equal(JSON.stringify(productObj.dispatchTime));
        } else if (prop === 'invoiceInfo') {
          (JSON.stringify(serializedProduct[prop]).length - JSON.stringify(productObj.invoiceInfo).length).should.equal(4);
        } else if (prop === 'subProducts') {
          (JSON.stringify(serializedProduct[prop]).length - JSON.stringify(productObj.subProducts).length).should.equal(8);
        }
      }
      done();
    });
  });

  describe('deserialize', function () {
    it('should correctly deserialize a composite type', function (done) {
      var client = new testClient('http://localhost:9090');
      var product = new client.models['Product']();
      mapper = product.mapper();
      var responseBody = {
        id: 101,
        name: 'TestProduct',
        properties: {
          provisioningState: 'Succeeded'
        },
        tags: {
          tag1: 'value1',
          tag2: 'value2'
        },
        dispatchTime: new Date('2015-01-01T12:35:36.009Z'),
        invoiceInfo: {
          invoiceId: 1002,
          invDate: '2015-12-25',
          invProducts: [
            {
              'Product1' : {
                id: 101,
                name: 'TestProduct'
              }
            },
            {
              'Product2' : {
                id: 104,
                name: 'TestProduct1'
              }
            }
          ]
        },
        subProducts: [
          {
            subId: 102,
            subName: 'SubProduct1',
            makeTime: new Date('2015-12-21T01:01:01'),
            invoiceInfo: {
              invoiceId: 1002,
              invDate: '2015-12-25'
            }
          },
          {
            subId: 103,
            subName: 'SubProduct2',
            makeTime: new Date('2015-12-21T01:01:01'),
            invoiceInfo: {
              invoiceId: 1003,
              invDate: '2015-12-25'
            }
          }
        ]
      };
      var deserializedProduct = client.deserialize(mapper, responseBody, 'responseBody', client);
      for (var prop in deserializedProduct) {
        if (prop === 'provisioningState') {
          deserializedProduct.provisioningState.should.equal(responseBody.properties.provisioningState);
        } else if (prop === 'id') {
          deserializedProduct[prop].should.equal(responseBody.id);
        } else if (prop === 'name') {
          deserializedProduct[prop].should.equal(responseBody.name);
        } else if (prop === 'tags') {
          JSON.stringify(deserializedProduct[prop]).should.equal(JSON.stringify(responseBody.tags));
        } else if (prop === 'dispatchTime') {
          JSON.stringify(deserializedProduct[prop]).should.equal(JSON.stringify(responseBody.dispatchTime));
        } else if (prop === 'invoiceInfo') {
          (JSON.stringify(deserializedProduct[prop]).length - JSON.stringify(responseBody.invoiceInfo).length).should.equal(10);
        } else if (prop === 'subProducts') {
          (JSON.stringify(deserializedProduct[prop]).length - JSON.stringify(responseBody.subProducts).length).should.equal(20);
        }
      }
      done();
    });
    
    it('should correctly deserialize a pageable type without nextLink', function (done) {
      var client = new testClient('http://localhost:9090');
      var productListResult = new client.models['ProductListResult']();
      mapper = productListResult.mapper();
      var responseBody = {
        value: [
          {
            id: 101,
            name: 'TestProduct',
            properties: {
              provisioningState: 'Succeeded'
            }
          },
          {
            id: 104,
            name: 'TestProduct1',
            properties: {
              provisioningState: 'Failed'
            }
          }
        ]
      };
      var deserializedProduct = client.deserialize(mapper, responseBody, 'responseBody');
      (util.isArray(deserializedProduct)).should.be.true;
      deserializedProduct.length.should.equal(2);
      for (var i = 0; i < deserializedProduct.length; i++) {
        if (i === 0) {
          deserializedProduct[i].id.should.equal(101);
          deserializedProduct[i].name.should.equal('TestProduct');
          deserializedProduct[i].provisioningState.should.equal('Succeeded');
        } else if (i === 1) {
          deserializedProduct[i].id.should.equal(104);
          deserializedProduct[i].name.should.equal('TestProduct1');
          deserializedProduct[i].provisioningState.should.equal('Failed');
        }
      }
      done();
    });
    
    it('should correctly deserialize a pageable type with nextLink', function (done) {
      var client = new testClient('http://localhost:9090');
      var productListResultNextLink = new client.models['ProductListResultNextLink']();
      mapper = productListResultNextLink.mapper();
      var responseBody = {
        value: [
          {
            id: 101,
            name: 'TestProduct',
            properties: {
              provisioningState: 'Succeeded'
            }
          },
          {
            id: 104,
            name: 'TestProduct1',
            properties: {
              provisioningState: 'Failed'
            }
          }
        ],
        nextLink: 'https://helloworld.com'
      };
      var deserializedProduct = client.deserialize(mapper, responseBody, 'responseBody');
      (util.isArray(deserializedProduct)).should.be.true;
      deserializedProduct.length.should.equal(2);
      deserializedProduct.nextLink.should.equal('https://helloworld.com');
      for (var i = 0; i < deserializedProduct.length; i++) {
        if (i === 0) {
          deserializedProduct[i].id.should.equal(101);
          deserializedProduct[i].name.should.equal('TestProduct');
          deserializedProduct[i].provisioningState.should.equal('Succeeded');
        } else if (i === 1) {
          deserializedProduct[i].id.should.equal(104);
          deserializedProduct[i].name.should.equal('TestProduct1');
          deserializedProduct[i].provisioningState.should.equal('Failed');
        }
      }
      done();
    });
  });
});

