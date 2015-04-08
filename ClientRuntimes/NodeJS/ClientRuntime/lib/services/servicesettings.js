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

var ut = require('util');
var url = require('url');

var util = require('../util/util');

var Constants = require('../util/constants');
var ConnectionStringParser = require('./connectionstringparser');

exports = module.exports;

/**
* The default protocol.
*/
exports.DEFAULT_PROTOCOL = Constants.HTTPS;

var NoMatchError = function (msg, constr) {
  Error.captureStackTrace(this, constr || this);
  this.message = msg || 'Error';
};

ut.inherits(NoMatchError, Error);
NoMatchError.prototype.name = 'NoMatchError';

exports.NoMatchError = NoMatchError;

/**
* Throws an exception if the connection string format does not match any of the
* available formats.
*
* @param {string} connectionString The invalid formatted connection string.
* @return none
*/
exports.noMatchConnectionString = function (connectionString) {
  throw new NoMatchError('The provided connection string "' + connectionString + '" does not have complete configuration settings.');
};

/**
* Throws an exception if the settings dont match any of the
* available formats.
*
* @param {object} settings The invalid settings.
* @return none
*/
exports.noMatchSettings = function (settings) {
  throw new NoMatchError('The provided settings ' + JSON.stringify(settings) + ' are not complete.');
};

/**
* Parses the connection string and then validate that the parsed keys belong to
* the validSettingKeys
*
* @param {string} connectionString The user provided connection string.
* @param {array}  validKeys        The valid keys.
* @return {array} The tokenized connection string keys.
*/
exports.parseAndValidateKeys = function (connectionString, validKeys) {
  var tokenizedSettings = ConnectionStringParser.parse(connectionString);

  // Assure that all given keys are valid.
  Object.keys(tokenizedSettings).forEach(function (key) {
    if (!util.inArrayInsensitive(key, validKeys)) {
      throw new Error('Invalid connection string setting key "' + key + '"');
    }
  });

  return tokenizedSettings;
};

/**
* Creates an anonymous function that acts as predicate to perform a validation.
*
* @param array   {requirements} The array of conditions to satisfy.
* @param boolean {isRequired}   Either these conditions are all required or all
* optional.
* @param boolean {atLeastOne}   Indicates that at least one requirement must
* succeed.
* @return {function}
*/
exports.getValidator = function (requirements, isRequired, atLeastOne) {
  return function (userSettings) {
    var oneFound = false;
    var result = { };

    for (var key in userSettings) {
      if (userSettings.hasOwnProperty(key)) {
        result[key.toLowerCase()] = userSettings[key];
      }
    }

    for (var requirement in requirements) {
      if (requirements.hasOwnProperty(requirement)) {
        var settingName = requirements[requirement].SettingName.toLowerCase();

        // Check if the setting name exists in the provided user settings.
        if (result[settingName]) {
          // Check if the provided user setting value is valid.
          var validationFunc = requirements[requirement].SettingConstraint;
          var isValid = validationFunc(result[settingName]);

          if (isValid) {
            // Remove the setting as indicator for successful validation.
            delete result[settingName];
            oneFound = true;
          }
        } else if (isRequired) {
          // If required then fail because the setting does not exist
          return null;
        }
      }
    }

    if (atLeastOne) {
      // At least one requirement must succeed, otherwise fail.
      return oneFound ? result : null;
    } else {
      return result;
    }
  };
};

/**
* Creates a setting value condition that validates it is one of the
* passed valid values.
*
* @param {string} name The setting key name.
* @return {array}
*/
exports.setting = function (name) {
  var validValues = Array.prototype.slice.call(arguments, 1, arguments.length);

  var predicate = function (settingValue) {
    var validValuesString = JSON.stringify(validValues);
    if (validValues.length === 0) {
      // No restrictions, succeed.
      return true;
    }

    // Check to find if the settingValue is valid or not.
    for (var index = 0; index < validValues.length; index++) {
      if (settingValue.toString() == validValues[index].toString()) {
        // SettingValue is found in valid values set, succeed.
        return true;
      }
    }

    // settingValue is missing in valid values set, fail.
    throw new Error('The provided config value ' + settingValue + ' does not belong to the valid values subset:\n' + validValuesString);
  };

  return exports.settingWithFunc(name, predicate);
};

/**
* Creates an "at lease one" predicate for the provided list of requirements.
*
* @return callable
*/
exports.atLeastOne = function () {
  var allSettings = arguments;
  return exports.getValidator(allSettings, false, true);
};

/**
* Creates an optional predicate for the provided list of requirements.
*
* @return {function}
*/
exports.optional = function () {
  var optionalSettings = arguments;
  return exports.getValidator(optionalSettings, false, false);
};

/**
* Creates an required predicate for the provided list of requirements.
*
* @return {function}
*/
exports.allRequired = function () {
  var requiredSettings = arguments;
  return exports.getValidator(requiredSettings, true, false);
};

/**
* Creates a setting value condition using the passed predicate.
*
* @param {string}   name      The setting key name.
* @param {function} predicate The setting value predicate.
* @return {array}
*/
exports.settingWithFunc = function (name, predicate) {
  var requirement = {};
  requirement.SettingName = name;
  requirement.SettingConstraint = predicate;

  return requirement;
};


/**
* Tests to see if a given list of settings matches a set of filters exactly.
*
* @param array $settings The settings to check.
* @return boolean If any filter returns null, false. If there are any settings
* left over after all filters are processed, false. Otherwise true.
*/
exports.matchedSpecification = function (settings) {
  var constraints = Array.prototype.slice.call(arguments, 1, arguments.length);

  for (var constraint in constraints) {
    if (constraints.hasOwnProperty(constraint)) {
      var remainingSettings = constraints[constraint](settings);

      if (!remainingSettings) {
        return false;
      } else {
        settings = remainingSettings;
      }
    }
  }

  return util.objectKeysLength(settings) === 0;
};

/*
* Returns a parsed host from a full host name.
*
* @param {string} uri The full host to be parsed.
* @return {object} THe parsed host as returned by the method "url.parse".
*/
exports.parseHost = function (uri) {
  var defaultedProtocol = false;
  if (uri.indexOf('http') === -1) {
    uri = exports.DEFAULT_PROTOCOL + '//' + uri;
    defaultedProtocol = true;
  }

  var parsedUrl = url.parse(uri);
  parsedUrl.defaultedProtocol = defaultedProtocol;
  return parsedUrl;
};