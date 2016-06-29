var express = require('express');
var router = express.Router();
var util = require('util');
var _ = require('underscore');
var utils = require('../util/utils');

var modelFlatten = function (coverage) {
  router.get('/:type', function (req, res, next) {
    if (req.params.type === 'array') {
      coverage['getModelFlattenArray']++;
      var result = [
        {
          id: '1',
          location: 'Building 44',
          name: 'Resource1',
          properties: {
            provisioningState: 'Succeeded',
            provisioningStateValues: 'OK',
            'p.name': 'Product1',
            type: 'Flat'
          },
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
      res.status(200).end(JSON.stringify(result));
    } else if (req.params.type === 'dictionary') {
      coverage['getModelFlattenDictionary']++;
      var result = {
        Product1: {
          id: '1',
          location: 'Building 44',
          name: 'Resource1',
          properties: {
            provisioningState: 'Succeeded',
            provisioningStateValues: 'OK',
            'p.name': 'Product1',
            type: 'Flat'
          },
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
      res.status(200).end(JSON.stringify(result));
    } else if (req.params.type === 'resourcecollection') {
      coverage['getModelFlattenResourceCollection']++;
      var result = {
        dictionaryofresources: {
          Product1: {
            id: '1',
            location: 'Building 44',
            name: 'Resource1',
            properties: {
              provisioningState: 'Succeeded',
              provisioningStateValues: 'OK',
              'p.name': 'Product1',
              type: 'Flat'
            },
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
            properties: {
              provisioningState: 'Succeeded',
              provisioningStateValues: 'OK',
              'p.name': 'Product4',
              type: 'Flat'
            },
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
      res.status(200).end(JSON.stringify(result));
    } else {
      utils.send400(res, next, "Request path must contain 'array', 'dictionary' or 'resourcecollection'");
    }
  });

  var arrayBody = '[{"location":"West US","tags":{"tag1":"value1","tag2":"value3"}},{"location":"Building 44"}]';

  var dictionaryBody = '{"Resource1":{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"},"properties":{"p.name":"Product1","type":"Flat"}},' +
                        '"Resource2":{"location":"Building 44", "properties":{"p.name":"Product2","type":"Flat"}}}';

  var resourceCollectionBody = '{"arrayofresources":[' +
                            '{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"}, "properties":{"p.name":"Product1","type":"Flat"}},' +
                            '{"location":"East US", "properties":{"p.name":"Product2","type":"Flat"}}],' +
                            '"dictionaryofresources":' + dictionaryBody + ',' +
                            '"productresource":{"location":"India", "properties":{"p.name":"Azure","type":"Flat"}}}';

  var customFlattenBody = {
    base_product_id: "123",
    base_product_description: "product description",
    details: {
      max_product_display_name: 'max name',
      max_product_capacity: "Large",
      max_product_image: {
        '@odata.value': "http://foo"
      }
    }
  };

  var customFlattenBodyWithInheritedProperty = {
    base_product_id: "123",
    base_product_description: "product description",
    details: {
      max_product_display_name: 'max name',
      max_product_capacity: "Large",
      max_product_image: {
        '@odata.value': "http://foo",
        'generic_value': "https://generic"
      }
    }
  };                      
  router.put('/:type', function (req, res, next) {
    if (req.body) {
      if (req.params.type === 'array') {
        if (_.isEqual(req.body, JSON.parse(arrayBody))) {
          coverage['putModelFlattenArray']++;
          res.status(200).end();
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + JSON.stringify(arrayBody) + "'.");
        }
      } else if (req.params.type === 'dictionary') {
        if (_.isEqual(req.body, JSON.parse(dictionaryBody))) {
          coverage['putModelFlattenDictionary']++;
          res.status(200).end();
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + JSON.stringify(dictionaryBody) + "'.");
        }
      } else if (req.params.type === 'resourcecollection') {
        if (_.isEqual(req.body, JSON.parse(resourceCollectionBody))) {
          coverage['putModelFlattenResourceCollection']++;
          res.status(200).end();
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + JSON.stringify(resourceCollectionBody) + "'.");
        }
      } else if (req.params.type === 'customFlattening') {
        if (_.isEqual(req.body, customFlattenBodyWithInheritedProperty)) {
          coverage['putModelFlattenCustomBase']++;
          res.status(200).end(JSON.stringify(customFlattenBodyWithInheritedProperty));
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + JSON.stringify(customFlattenBody) + "'.");
        }
      }
    } else {
      utils.send400(res, next, "Was expecting a body in the put request.");
    }
  });

  router.post('/:type', function (req, res, next) {
    if (req.body) {
      if (req.params.type === 'customFlattening') {
        if (_.isEqual(req.body, customFlattenBody)) {
          coverage['postModelFlattenCustomParameter']++;
          res.status(200).end(JSON.stringify(customFlattenBody));
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + JSON.stringify(customFlattenBody) + "'.");
        }
      }
    } else {
      utils.send400(res, next, "Was expecting a body in the put request.");
    }
  });

  router.put('/customFlattening/parametergrouping/:name', function (req, res, next) {
    if (req.body) {
      if (_.isEqual(req.body, customFlattenBody) && req.params.name === 'groupproduct') {
        coverage['putModelFlattenCustomGroupedParameter']++;
        res.status(200).end(JSON.stringify(customFlattenBody));
      } else {
        utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + JSON.stringify(customFlattenBody) + 
          "'. Or the path parameter name does not have the value 'groupproduct'");
      }
    } else {
      utils.send400(res, next, "Was expecting a body in the put request.");
    }
  });
};

modelFlatten.prototype.router = router;

module.exports = modelFlatten;