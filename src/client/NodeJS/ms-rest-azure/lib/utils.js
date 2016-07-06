// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var uuid = require('uuid');

/**
* Generated UUID
*
* @return {string} RFC4122 v4 UUID.
*/
exports.generateUuid = function () {
  return uuid.v4();
};

exports = module.exports;
