var express = require('express');
var router = express.Router();
var util = require('util');
var _ = require('underscore');
var utils = require('../util/utils');

var resourceFlatten = function (coverage) {
  coverage['getResourceFlattenArray'] = 0;
  coverage['putResourceFlattenArray'] = 0;
  coverage['getResourceFlattenDictionary'] = 0;
  coverage['putResourceFlattenDictionary'] = 0;
  coverage['getResourceFlattenResourceCollection'] = 0;
  coverage['putResourceFlattenResourceCollection'] = 0;
  router.get('/:type', function (req, res, next) {
    if (req.params.type === 'array') {
      coverage['getResourceFlattenArray']++;
      var result = [
        {
          id: '1',
          location: 'Building 44',
          name: 'Resource1',
          properties: {
            provisioningState: 'Succeeded',
            provisioningStateValues: 'OK',
            pname: 'Product1',
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
      coverage['getResourceFlattenDictionary']++;
      var result = {
        Product1: {
          id: '1',
          location: 'Building 44',
          name: 'Resource1',
          properties: {
            provisioningState: 'Succeeded',
            provisioningStateValues: 'OK',
            pname: 'Product1',
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
      coverage['getResourceFlattenResourceCollection']++;
      var result = {
        dictionaryofresources: {
          Product1: {
            id: '1',
            location: 'Building 44',
            name: 'Resource1',
            properties: {
              provisioningState: 'Succeeded',
              provisioningStateValues: 'OK',
              pname: 'Product1',
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
              pname: 'Product4',
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

  var dictionaryBody = '{"Resource1":{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"},"properties":{"pname":"Product1","type":"Flat"}},' +
                        '"Resource2":{"location":"Building 44", "properties":{"pname":"Product2","type":"Flat"}}}';

  var resourceCollectionBody = '{"arrayofresources":[' +
                            '{"location":"West US", "tags":{"tag1":"value1", "tag2":"value3"}, "properties":{"pname":"Product1","type":"Flat"}},' +
                            '{"location":"East US", "properties":{"pname":"Product2","type":"Flat"}}],' +
                            '"dictionaryofresources":' + dictionaryBody + ',' +
                            '"productresource":{"location":"India", "properties":{"pname":"Azure","type":"Flat"}}}';
  router.put('/:type', function (req, res, next) {
    if (req.body) {
      if (req.params.type === 'array') {
        coverage['putResourceFlattenArray']++;
        if (_.isEqual(req.body, JSON.parse(arrayBody))) {
          res.status(200).end();
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + arrayBody + "'.");
        }
      } else if (req.params.type === 'dictionary') {
        coverage['putResourceFlattenDictionary']++;
        if (_.isEqual(req.body, JSON.parse(dictionaryBody))) {
          res.status(200).end();
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + dictionaryBody + "'.");
        }
      } else if (req.params.type === 'resourcecollection') {
        coverage['putResourceFlattenResourceCollection']++;
        if (_.isEqual(req.body, JSON.parse(resourceCollectionBody))) {
          res.status(200).end();
        } else {
          utils.send400(res, next, "The received body '" + JSON.stringify(req.body) + "' did not match the expected body '" + resourceCollectionBody + "'.");
        }
      }
    } else {
      utils.send400(res, next, "Was expecting a body in the put request.");
    }
  });
};

resourceFlatten.prototype.router = router;

module.exports = resourceFlatten;