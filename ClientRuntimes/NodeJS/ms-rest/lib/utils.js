// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var _ = require('underscore');
var Constants = require('./constants');

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
* Provides the version of nodejs on the system.
*
* @return {object} An object specifying the major, minor and patch version of nodejs on the system.
*/
exports.getNodeVersion = function () {
  var parsedVersion = process.version.split('.');
  return {
    major: parseInt(parsedVersion[0].substr(1), 10),
    minor: parseInt(parsedVersion[1], 10),
    patch: parseInt(parsedVersion[2], 10)
  };
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
 * Returns a stripped version of the Http Response which only contains body, 
 * headers and the statusCode.
 * 
 * @param {stream} response - The Http Response
 * 
 * @return {object} strippedResponse - The stripped version of Http Response.
 */
exports.stripResponse = function (response) {
  var strippedResponse = {};
  strippedResponse.body = response.body;
  strippedResponse.headers = response.headers;
  strippedResponse.statusCode = response.statusCode;
  return strippedResponse;
};

/**
 * Returns a stripped version of the Http Request that does not contain the 
 * Authorization header.
 * 
 * @param {object} request - The Http Request object
 * 
 * @return {object} strippedRequest - The stripped version of Http Request.
 */
exports.stripRequest = function (request) {
  var strippedRequest = {};
  try {
    strippedRequest = JSON.parse(JSON.stringify(request));
    if (strippedRequest.headers && strippedRequest.headers.Authorization) {
      delete strippedRequest.headers.Authorization;
    } else if (strippedRequest.headers && strippedRequest.headers.authorization) {
      delete strippedRequest.headers.authorization;
    }
  } catch (err) {
    var errMsg = err.message;
    err.message = util.format('Error - "%s" occured while creating a stripped version of the request object - "%s".', errMsg, request);
    return err;
  }
  
  return strippedRequest;
};

exports = module.exports;
