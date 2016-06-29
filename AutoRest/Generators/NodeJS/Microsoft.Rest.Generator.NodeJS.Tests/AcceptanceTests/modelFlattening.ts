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

import flatteningClient = require('../Expected/AcceptanceTests/ModelFlattening/autoRestResourceFlatteningTestService');
import flatteningClientModels = require('../Expected/AcceptanceTests/ModelFlattening/models');

var clientOptions = {};
var baseUri = 'http://localhost:3000';

describe('nodejs', function () {

  describe('Swagger ModelFlattening BAT', function () {

    describe('Resource Flattening Operations', function () {
      var testClient = new flatteningClient(baseUri, clientOptions);

      it('should get external resource as an array', function (done) {
        var expectedResult = [
          {
            id: '1',
            location: 'Building 44',
            name: 'Resource1',
            provisioningState: 'Succeeded',
            provisioningStateValues: 'OK',
            pname: 'Product1',
            flattenedProductType: 'Flat',
            tags: { tag1: 'value1', tag2: 'value3' },
            type: 'Microsoft.Web/sites'
          },
          {
            id: '2',
            name: 'Resource2',
            location: 'Building 44'
          },
          {
            id: '3',
            name: 'Resource3'
          }
        ];
        testClient.getArray(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result, expectedResult);
          done();
        });
      });

      it('should put external resource as an array', function (done) {
        var resourceBody = [
          <flatteningClientModels.Resource> { "location": "West US", "tags": { "tag1": "value1", "tag2": "value3" }, "pname": "Product1", "flattenedProductType": "Flat" },
          <flatteningClientModels.Resource> { "location": "Building 44", "pname": "Product2" }
        ];
        testClient.putArray({ resourceArray: resourceBody }, function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should get external resource as a dictionary', function (done) {
        var expectedResult = {
          Product1: {
            id: '1',
            location: 'Building 44',
            name: 'Resource1',
            provisioningState: 'Succeeded',
            provisioningStateValues: 'OK',
            pname: 'Product1',
            flattenedProductType: 'Flat',
            tags: { tag1: 'value1', tag2: 'value3' },
            type: 'Microsoft.Web/sites'
          },
          Product2: {
            id: '2',
            name: 'Resource2',
            location: 'Building 44'
          },
          Product3: {
            id: '3',
            name: 'Resource3'
          }
        };
        testClient.getDictionary(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result, expectedResult);
          done();
        });
      });

      it('should put external resource as a dictionary', function (done) {
        var resourceBody: { [propertyName: string]: flatteningClientModels.FlattenedProduct } =  {
          "Resource1":  { "location": "West US", "tags": { "tag1": "value1", "tag2": "value3" }, "pname": "Product1", "flattenedProductType": "Flat" },
          "Resource2": { "location": "Building 44", "pname": "Product2", "flattenedProductType": "Flat" }
        };
        testClient.putDictionary({ resourceDictionary: resourceBody }, function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should get external resource as a complex type', function (done) {
        var expectedResult = {
          dictionaryofresources: {
            Product1: {
              id: '1',
              location: 'Building 44',
              name: 'Resource1',
              provisioningState: 'Succeeded',
              provisioningStateValues: 'OK',
              pname: 'Product1',
              flattenedProductType: 'Flat',
              tags: { tag1: 'value1', tag2: 'value3' },
              type: 'Microsoft.Web/sites'
            },
            Product2: {
              id: '2',
              name: 'Resource2',
              location: 'Building 44'
            },
            Product3: {
              id: '3',
              name: 'Resource3'
            }
          },
          arrayofresources: [
            {
              id: '4',
              location: 'Building 44',
              name: 'Resource4',
              provisioningState: 'Succeeded',
              provisioningStateValues: 'OK',
              pname: 'Product4',
              flattenedProductType: 'Flat',
              tags: { tag1: 'value1', tag2: 'value3' },
              type: 'Microsoft.Web/sites'
            },
            {
              id: '5',
              name: 'Resource5',
              location: 'Building 44'
            },
            {
              id: '6',
              name: 'Resource6'
            }
          ],
          productresource: {
            id: '7',
            name: 'Resource7',
            location: 'Building 44'
          }
        };
        testClient.getResourceCollection(function (error, result) {
          should.not.exist(error);
          assert.deepEqual(result, expectedResult);
          done();
        });
      });

      it('should put external resource as a complex type', function (done) {
        var resourceBody = <flatteningClientModels.ResourceCollection>{
          "arrayofresources": [
            {"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"}, "pname":"Product1", "flattenedProductType": "Flat" },
            { "location": "East US", "pname": "Product2", "flattenedProductType": "Flat" }
          ],
          "dictionaryofresources": {
            "Resource1": { "location": "West US", "tags": { "tag1": "value1", "tag2": "value3" }, "pname": "Product1", "flattenedProductType": "Flat" },
            "Resource2": { "location": "Building 44", "pname": "Product2", "flattenedProductType": "Flat" }
          },
          "productresource": { "location": "India", "pname": "Azure", "flattenedProductType": "Flat" }
        };
        testClient.putResourceCollection({ resourceComplexObject: resourceBody }, function (error, result) {
          should.not.exist(error);
          done();
        });
      });

      it('should put simple product to flatten', function (done) {
        var resourceBody = <flatteningClientModels.SimpleProduct>{
          productId: "123",
          description: "product description",
          maxProductDisplayName: "max name",
          odatavalue: "http://foo",
          genericValue: "https://generic"
        };
        testClient.putSimpleProduct({ simpleBodyProduct: resourceBody }, function (error, result) {
          should.not.exist(error);
          var newResourceBody = JSON.parse(JSON.stringify(resourceBody));
          newResourceBody.capacity = "Large";
          assert.deepEqual(result, newResourceBody);
          done();
        });
      });

      it('should post simple product with param flattening', function (done) {
        var resourceBody = <flatteningClientModels.SimpleProduct>{
            productId: "123",
            description: "product description",
          maxProductDisplayName: "max name",
          odatavalue: "http://foo"
        };
        testClient.postFlattenedSimpleProduct("123", "max name", { description: "product description", odatavalue: "http://foo" }, function (error, result) {
          should.not.exist(error);
          var newResourceBody = JSON.parse(JSON.stringify(resourceBody));
          newResourceBody.capacity = "Large";
          assert.deepEqual(result, newResourceBody);
          done();
        });
      });

      it('should put flattened and grouped product', function (done) {
        var resourceBody = <flatteningClientModels.SimpleProduct>{
          productId: "123",
          description: "product description",
          maxProductDisplayName: "max name",
          odatavalue: "http://foo"
        };
        var paramGroup = <flatteningClientModels.FlattenParameterGroup>{
          productId: "123",
          description: "product description",
          maxProductDisplayName: "max name",
          odatavalue: "http://foo",
          name: "groupproduct"
        };
        testClient.putSimpleProductWithGrouping(paramGroup, function (error, result) {
          should.not.exist(error);
          var newResourceBody = JSON.parse(JSON.stringify(resourceBody));
          newResourceBody.capacity = "Large";
          assert.deepEqual(result, newResourceBody);
          done();
        });
      });
    });
  });
});
