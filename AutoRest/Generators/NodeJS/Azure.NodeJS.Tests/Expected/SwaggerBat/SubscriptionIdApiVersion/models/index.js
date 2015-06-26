
/* jshint latedef:false */
/* jshint forin:false */
/* jshint noempty:false */

'use strict';

var msRestAzure = require('ms-rest-azure');

exports.Resource = msRestAzure.Resource;
exports.CloudError = msRestAzure.CloudError;
exports.Group = require('./Group');
exports.ErrorModel = require('./ErrorModel');
