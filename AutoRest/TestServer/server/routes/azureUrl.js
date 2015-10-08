var express = require('express');
var router = express.Router();
var util = require('util');
var constants = require('../util/constants');
var utils = require('../util/utils')

var azureUrl = function (coverage) {
  coverage['SubscriptionIdAndApiVersion'] = 0;
  router.get('/:subscriptionId/resourcegroups/:resourceGroup', function (req, res, next) {
    var subscriptionId = req.params.subscriptionId;
    var apiVersion = req.query['api-version'];
    var groupName = req.params.resourceGroup;
    var queryParamCount = Object.keys(req.query).length;
    if (!subscriptionId || typeof subscriptionId !== 'string') {
      utils.send400(res, next, 'The provided subscriptionId ' + util.inspect(subscriptionId) +
        'is not defined or is not of type string');
    } else if (queryParamCount !== 1 || apiVersion !== '2014-04-01-preview') {
      utils.send400(res, next, 'The provided api-version ' + util.inspect(apiVersion) +
        'is not equal to "2014-04-01-preview".');
    } else {
      coverage['SubscriptionIdAndApiVersion']++;
      var result = {name: 'testgroup101', location: 'West US'};
      res.status(200).end(JSON.stringify(result));
    }
  });
}

azureUrl.prototype.router = router;

module.exports = azureUrl;