// 
// Copyright (c) Microsoft and contributors.  All rights reserved.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 
// See the License for the specific language governing permissions and
// limitations under the License.
// 

var _ = require('underscore');
var azureutil = require('./util');

/**
* Get the Edm type of an object.
*
* @param {object} value A typed instance.
* @return {string} The Edm type.
*/
exports.propertyType = function (value) {
  if (_.isNumber(value)) {
    if (azureutil.objectIsInt(value)) {
      if (Math.abs(value) < Math.pow(2, 31)) {
        return 'Edm.Int32';
      } else {
        return 'Edm.Int64';
      }
    } else {
      return 'Edm.Double';
    }
  } else if (_.isDate(value)) {
    return 'Edm.DateTime';
  } else if (_.isBoolean(value)) {
    return 'Edm.Boolean';
  } else {
    return 'Edm.String';
  }
};

exports.serializeValue = function (type, value) {
  switch(type) {
  case 'Edm.Double':
  case 'Edm.Int32':
  case 'Edm.Int64':
  case 'Edm.Guid':
  case 'Edm.String':
  case null:
    if (!_.isNull(value) && !_.isUndefined(value)) {
      return value.toString();
    }

    return '';
  case 'Edm.Binary':
    return new Buffer(value).toString('base64').trim('\n');
  case 'Edm.Boolean':
    if (value !== undefined) {
      return value === true ? '1' : '0';
    }

    return '';
  case 'Edm.DateTime':
    if (!_.isDate(value)) {
      value = new Date(value);
    }

    return value.toISOString();
  default:
    return value.toString();
  }
};

/**
* Convert a serialized value into an typed object.
* 
* @param {string} type  The type of the value as it appears in the type attribute.
* @param {string} value The value in string format.
* @return {object} The typed value.
*/
exports.unserializeValue = function (type, value) {
  switch (type) {
  case 'Edm.Binary':
    return new Buffer(value, 'base64').toString('ascii');

  case 'Edm.Boolean':
    return value === 'true' || value === '1';

  case 'Edm.DateTime':
  case 'Edm.DateTimeOffset':
    return new Date(value);

  case 'Edm.Decimal':
  case 'Edm.Double':
    return parseFloat(value);

  case 'Edm.Int16':
  case 'Edm.Int32':
  case 'Edm.Int64':
    return parseInt(value, 10);

  case 'Edm.Byte':
  case 'Edm.SByte':
  case 'Edm.Single':
  case 'Edm.String':
  case 'Edm.Time':
  case 'Edm.Guid':
    return value;

  default:
    return value;
  }
};

/**
* Serializes value into proper value to be used in odata query value.
*
* @param {object} value The value to be serialized.
* @return {string} The serialized value.
*/
exports.serializeQueryValue = function (value) {
  if (_.isNumber(value)) {
    return value.toString();
  } else if (_.isDate(value)) {
    return 'datetime\'' + value.toISOString() + '\'';
  } else if (_.isBoolean(value)) {
    return value ? 'true' : 'false';
  } else {
    return '\'' + value.toString().replace(/'/g, '\'\'') + '\'';
  }
};