
/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

var msRestAzure = require('ms-rest-azure');

exports.Resource = msRestAzure.Resource;
exports.CloudError = msRestAzure.CloudError;
exports.SampleResourceGroup = require('./SampleResourceGroup');
exports.ErrorModel = require('./ErrorModel');
