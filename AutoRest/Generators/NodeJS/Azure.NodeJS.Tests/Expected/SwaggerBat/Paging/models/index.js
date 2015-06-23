
/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

var msRestAzure = require('ms-rest-azure');

exports.Resource = msRestAzure.Resource;
exports.CloudError = msRestAzure.CloudError;
exports.ProductResult = require('./ProductResult');
exports.Product = require('./Product');
exports.ProductProperties = require('./ProductProperties');
exports.OperationResult = require('./OperationResult');
