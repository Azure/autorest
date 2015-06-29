
/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

var msRestAzure = require('ms-rest-azure');

exports.Resource = msRestAzure.Resource;
exports.CloudError = msRestAzure.CloudError;
exports.ErrorModel = require('./ErrorModel');
exports.FlattenedProduct = require('./FlattenedProduct');
exports.FlattenedProductProperties = require('./FlattenedProductProperties');
exports.ResourceCollection = require('./ResourceCollection');
