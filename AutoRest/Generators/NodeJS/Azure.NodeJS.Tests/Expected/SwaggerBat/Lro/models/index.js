
/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

var msRestAzure = require('ms-rest-azure');

exports.Resource = msRestAzure.Resource;
exports.CloudError = msRestAzure.CloudError;
exports.Sku = require('./Sku');
exports.Product = require('./Product');
exports.ProductProperties = require('./ProductProperties');
exports.SubProduct = require('./SubProduct');
exports.SubProductProperties = require('./SubProductProperties');
exports.OperationResult = require('./OperationResult');
exports.OperationResultError = require('./OperationResultError');
