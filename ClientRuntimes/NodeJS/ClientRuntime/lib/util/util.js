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

var fs = require('fs');
var path = require('path');
var crypto = require('crypto');
var _ = require('underscore');
var Constants = require('./constants');

/**
* Encodes an URI.
*
* @param {string} uri The URI to be encoded.
* @return {string} The encoded URI.
*/
exports.encodeUri = function (uri) {
  return encodeURIComponent(uri)
    .replace(/!/g, '%21')
    .replace(/'/g, '%27')
    .replace(/\(/g, '%28')
    .replace(/\)/g, '%29')
    .replace(/\*/g, '%2A');
};

/**
* Returns the number of keys (properties) in an object.
*
* @param {object} value The object which keys are to be counted.
* @return {number} The number of keys in the object.
*/
exports.objectKeysLength = function (value) {
  if (!value) {
    return 0;
  }

  return _.keys(value).length;
};

/**
* Returns the name of the first property in an object.
*
* @param {object} value The object which key is to be returned.
* @return {number} The name of the first key in the object.
*/
exports.objectFirstKey = function (value) {
  if (value && Object.keys(value).length > 0) {
    return Object.keys(value)[0];
  }

  // Object has no properties
  return null;
};

/**
* Checks if a value is null or undefined.
*
* @param {object} value The value to check for null or undefined.
* @return {bool} True if the value is null or undefined, false otherwise.
*/
exports.objectIsNull = function (value) {
  return _.isNull(value) || _.isUndefined(value);
};

/**
* Checks if an object is empty.
*
* @param {object} object The object to check if it is null.
* @return {bool} True if the object is empty, false otherwise.
*/
exports.objectIsEmpty = function (object) {
  return _.isEmpty(object);
};

/**
* Determines if an object contains an integer number.
*
* @param {object}  value  The object to assert.
* @return {bool} True if the object contains an integer number; false otherwise.
*/
exports.objectIsInt = function (value) {
  return typeof value === 'number' && parseFloat(value) == parseInt(value, 10) && !isNaN(value);
};

/**
* Checks if an object is a string.
*
* @param {object} object The object to check if it is a string.
* @return {bool} True if the object is a strign, false otherwise.
*/
exports.objectIsString = function (object) {
  return _.isString(object);
};

/**
* Check if an object is a function
* @param {object} object The object to check whether it is function
* @return {bool} True if the specified object is function, otherwise false
*/
exports.objectIsFunction = function (object) {
  return _.isFunction(object);
};


/**
* Front zero padding of string to sepcified length
*/
exports.zeroPaddingString = function(str, len) {
  var paddingStr = '0000000000' + str;
  if(paddingStr.length < len) {
    return exports.zeroPaddingString(paddingStr, len);
  } else {
    return paddingStr.substr(-1 * len);
  }
};

/**
* Checks if a value is an empty string, null or undefined.
*
* @param {object} value The value to check for an empty string, null or undefined.
* @return {bool} True if the value is an empty string, null or undefined, false otherwise.
*/
exports.stringIsEmpty = function (value) {
  return _.isNull(value) || _.isUndefined(value) || value === '';
};

/**
* Formats a text replacing '?' by the arguments.
*
* @param {string}       text      The string where the ? should be replaced.
* @param {array}        arguments Value(s) to insert in question mark (?) parameters.
* @return {string}
*/
exports.stringFormat = function (text) {
  if (arguments.length > 1) {
    for (var i = 0; text.indexOf('?') !== -1; i++) {
      text = text.replace('?', arguments[i + 1]);
    }
  }

  return text;
};

/**
* Determines if a string starts with another.
*
* @param {string}       text      The string to assert.
* @param {string}       prefix    The string prefix.
* @return {Bool} True if the string starts with the prefix; false otherwise.
*/
exports.stringStartsWith = function (text, prefix) {
  if (_.isNull(prefix)) {
    return true;
  }

  return text.substr(0, prefix.length) === prefix;
};

/**
* Determines if a string ends with another.
*
* @param {string}       text      The string to assert.
* @param {string}       suffix    The string suffix.
* @return {Bool} True if the string ends with the suffix; false otherwise.
*/
exports.stringEndsWith = function (text, suffix) {
  if (_.isNull(suffix)) {
    return true;
  }

  return text.substr(text.length - suffix.length) === suffix;
};

/**
* Determines if a string contains an integer number.
*
* @param {string}       text      The string to assert.
* @return {Bool} True if the string contains an integer number; false otherwise.
*/
exports.stringIsInt = function (value) {
  if (!value) {
    return false;
  }

  var intValue = parseInt(value, 10);
  return intValue.toString().length === value.length &&
         intValue === parseFloat(value);
};

/**
* Determines if a string contains a float number.
*
* @param {string}       text      The string to assert.
* @return {Bool} True if the string contains a float number; false otherwise.
*/
exports.stringIsFloat = function (value) {
  if (!value) {
    return false;
  }

  var floatValue = parseFloat(value);
  return floatValue.toString().length === value.length &&
         parseInt(value, 10) !== floatValue;
};

/**
* Determines if a string contains a number.
*
* @param {string}       text      The string to assert.
* @return {Bool} True if the string contains a number; false otherwise.
*/
exports.stringIsNumber = function (value) {
  return !isNaN(value);
};

/**
* Determines if a date object is valid.
*
* @param {Date} date The date to test
* @return {Bool} True if the date is valid; false otherwise.
*/
exports.stringIsDate = function (date) {
  if (Object.prototype.toString.call(date) !== '[object Date]') {
    return false;
  }

  return !isNaN(date.getTime());
};

/**
* Checks if a parsed URL is HTTPS
*
* @param {object} urlToCheck The url to check
* @return {bool} True if the URL is HTTPS; false otherwise.
*/
exports.urlIsHTTPS = function (urlToCheck) {
  return urlToCheck.protocol.toLowerCase() === Constants.HTTPS;
};

/**
* Removes the BOM from a string.
*
* @param {string} str The string from where the BOM is to be removed
* @return {string} The string without the BOM.
*/
exports.removeBOM = function (str) {
  if (str.charCodeAt(0) === 0xfeff || str.charCodeAt(0) === 0xffef) {
    str = str.substring(1);
  }

  return str;
};

/**
* Merges multiple objects.
*
* @param {object} object The objects to be merged
* @return {object} The merged object.
*/
exports.merge = function () {
  return _.extend.apply(this, arguments);
};

/**
* Checks if a value exists in an array. The comparison is done in a case
* insensitive manner.
*
* @param {string} needle     The searched value.
* @param {array}  haystack   The array.
*
* @static
*
* @return {boolean}
*/
exports.inArrayInsensitive = function (needle, haystack) {
  return _.contains(_.map(haystack, function (h) { return h.toLowerCase(); }), needle.toLowerCase());
};

/**
* Returns the specified value of the key passed from object and in case that
* this key doesn't exist, the default value is returned. The key matching is
* done in a case insensitive manner.
*
* @param {string} key      The array key.
* @param {object} haystack The object to be used.
* @param {mix}    default  The value to return if $key is not found in $array.
*
* @static
*
* @return mix
*/
exports.tryGetValueInsensitive = function (key, haystack, defaultValue) {
  if (haystack) {
    for (var i in haystack) {
      if (haystack.hasOwnProperty(i) && i.toString().toLowerCase() === key.toString().toLowerCase()) {
        return haystack[i];
      }
    }
  }

  return defaultValue;
};

function longUnsignedRor(value, count) {
  for(var i = 0; i<count; i++) {
    value = value / 2;
  }
  return Math.floor(value);
}

var base32StandardAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
function base32NoPaddingEncode (data) {
  var result = '';
  for (var i = 0; i < data.length; i+=5) {

    // Process input 5 bytes at a time
    var multiplier = 256;
    var loopValue = 0;
    for (var j = Math.min(data.length-1, i+4); j >= i ; j--) {
      loopValue += data[j] * multiplier;
      multiplier = multiplier * 256;
    }

    // Converts them into base32
    var bytes = Math.min(data.length - i, 5);
    for (var bitOffset = (bytes+1)*8 - 5; bitOffset > 3; bitOffset -= 5) {
      var index = longUnsignedRor(loopValue,bitOffset) % 32;
      result += base32StandardAlphabet[index];
    }
  }
  return result;
}

/**
* Returns the namespace for a subscriptoinId, prefix and location
*
* @subscriptionId {string}  The Azure subscription id.
* @prefix {string}          The prifix for the service.
* @location {string}        The location of the service.
* @return {Bool}   True if the value is an integer number; false otherwise.
*/
exports.getNameSpace = function (subscriptionId, prefix, location) {
  location = location.replace(/ /g, '-');
  var hash = crypto.createHash('sha256').update(new Buffer(subscriptionId, 'utf-8')).digest('hex');
  return prefix + base32NoPaddingEncode(new Buffer(hash, 'hex')) + '-' + location;
};

/**
* Determines if a value (string or number) is an integer number.
*
* @param {object}  The value to assess.
* @return {Bool}   True if the value is an integer number; false otherwise.
*/
exports.isInt = function (value){
  if((parseFloat(value) == parseInt(value, 10)) && !isNaN(value)) {
    return true;
  }
  else {
    return false;
  }
};

/**
* Returns the value in a chained object.
*
* @param {object} object   The object with the values.
* @param {array}  keys     The keys.
* @param {mix}    default  The value to return if $key is not found in $array.
*
* @static
*
* @return mix
*/
exports.tryGetValueChain = function (object, keys, defaultValue) {
  if (keys.length === 0) {
    return object;
  }

  var currentKey = keys.shift();
  if (object && object[currentKey]) {
    return exports.tryGetValueChain(object[currentKey], keys, defaultValue);
  }

  return defaultValue;
};

/**
* Rounds a date off to seconds.
*
* @param {Date} a date
* @return {string} the date in ISO8061 format, with no milliseconds component
*/
exports.truncatedISO8061Date = function (date) {
  var dateString = date.toISOString();
  return dateString.substring(0, dateString.length - 5) + 'Z';
};

exports.normalizeArgs = function (optionsOrCallback, callback, result) {
  var options = {};
  if(_.isFunction(optionsOrCallback) && !callback) {
    callback = optionsOrCallback;
  } else if (optionsOrCallback) {
    options = optionsOrCallback;
  }

  result(options, callback);
};

exports.getNodeVersion = function () {
  var parsedVersion = process.version.split('.');
  return {
    major: parseInt(parsedVersion[0].substr(1), 10),
    minor: parseInt(parsedVersion[1], 10),
    patch: parseInt(parsedVersion[2], 10)
  };
};

exports.analyzeStream = function (stream, calculateMD5, callback) {
  var digest = null;
  var length = 0;
  if (calculateMD5) {
    digest = crypto.createHash('md5');
  }

  stream.on('data', function (chunk) {
    if (calculateMD5) {
      digest.update(chunk);
    }

    length += chunk.length;
  });

  stream.on('end', function () {
    var md5 = null;
    if (calculateMD5) {
      md5 = digest.digest('base64');
    }

    callback(length, md5);
  });
};


/**
* Whether the content of buffer is all zero
*/
exports.isBufferAllZero = function (buffer) {
  for(var i = 0, len = buffer.length; i < len; i++) {
    if (buffer[i] !== 0) {
      return false;
    }
  }
  return true;
};

/**
* Write zero to stream
*/
var zeroBuffer = null;
exports.writeZeroToStream = function(stream, length, md5Hash, progressCallback, callback) {
  var defaultBufferSize = Constants.BlobConstants.DEFAULT_WRITE_BLOCK_SIZE_IN_BYTES;
  var bufferSize = Math.min(defaultBufferSize, length);
  var remaining = length - bufferSize;
  var buffer = null;
  if(bufferSize == defaultBufferSize) {
    if(!zeroBuffer) {
      zeroBuffer = new Buffer(defaultBufferSize);
      zeroBuffer.fill(0);
    }
    buffer = zeroBuffer;
  } else {
    buffer = new Buffer(bufferSize);
    buffer.fill(0);
  }
  if(md5Hash) {
    md5Hash.update(buffer);
  }
  //We can only write the entire buffer to stream instead of part of buffer.
  return stream.write(buffer, function() {
    if (exports.objectIsFunction(progressCallback)) {
      progressCallback(null, buffer.length);
    }
    buffer = null;
    if (remaining > 0) {
      exports.writeZeroToStream(stream, remaining, md5Hash, progressCallback, callback);
    } else if (exports.objectIsFunction(callback)) {
      callback(null, null);
    }
  });
};

/**
* Calculate md5sum for the content
*/
exports.getContentMd5 = function (content, encoding) {
  if (!encoding) encoding = 'base64';
  var internalHash = crypto.createHash('md5');
  internalHash.update(content);
  return internalHash.digest(encoding);
};

exports.pathExistsSync = fs.existsSync ? fs.existsSync : path.existsSync;
