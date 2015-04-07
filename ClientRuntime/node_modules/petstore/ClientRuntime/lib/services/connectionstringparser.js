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

// Expose 'ConnectionStringParser'.
exports = module.exports;

/**
* Creates a new 'ConnectionString' instance.
*
* @constructor
* @param {string} connectionString The connection string to be parsed.
*/
function ConnectionStringParser(connectionString) {
  this._value = connectionString;
  this._pos = 0;
  this._state = 'ExpectKey';
}

/**
* Parses a connection string into an object.
*
* @return {object} The query string object.
*/
ConnectionStringParser.prototype._parse = function (options) {
  var key = null;
  var value = null;
  var parsedConnectionString = { };

  for (; ;) {
    this._skipWhitespaces();

    if (this._pos === this._value.length && this._state !== 'ExpectValue')
    {
      // Not stopping after the end has been reached and a value is expected
      // results in creating an empty value, which we expect.
      break;
    }

    switch (this._state) {
    case 'ExpectKey':
      key = this._extractKey();
      this._state = 'ExpectAssignment';
      break;

    case 'ExpectAssignment':
      this._skipOperator('=');
      this._state = 'ExpectValue';
      break;

    case 'ExpectValue':
      value = this._extractValue();
      this._state = 'ExpectSeparator';

      if (options && options.skipLowerCase) {
        parsedConnectionString[key] = value;
      } else {
        parsedConnectionString[key.toLowerCase()] = value;
      }

      key = null;
      value = null;
      break;

    default:
      this._skipOperator(';');
      this._state = 'ExpectKey';
      break;
    }
  }

  if (this._state === 'ExpectAssignment') {
    // Must end parsing in the valid state (expected key or separator)
    throw new Error('Missing character "="');
  }

  return parsedConnectionString;
};


/**
* Skips whitespaces at the current position.
*/
ConnectionStringParser.prototype._skipWhitespaces = function () {
  while (this._pos < this._value.length && this._value[this._pos] === ' ')
  {
    this._pos++;
  }
};

/**
* Extracts key at the current position.
*
* @return {string} Key.
*/
ConnectionStringParser.prototype._extractKey = function () {
  var key = null;
  var firstPos = this._pos;
  var ch = this._value[this._pos++];

  if (ch === '"' || ch === '\'') {
    key = this._extractString(ch);
  } else if (ch === ';' || ch === '=') {
    // Key name was expected.
    throw new Error('Missing key');
  } else {
    while (this._pos < this._value.length) {
      ch = this._value[this._pos];
      if (ch === '=') {
        break;
      }
      this._pos++;
    }

    key = this._value.substring(firstPos, this._pos);
  }

  if (key.length === 0) {
    // Empty key name.
    throw new Error('Empty key name');
  }

  return key;
};

/**
* Extracts the string until the given quotation mark.
*
* @param {string} quote Quotation mark terminating the string.
* @return {string} string.
*/
ConnectionStringParser.prototype._extractString = function (quote) {
  var firstPos = this._pos;
  while (this._pos < this._value.length && this._value[this._pos] !== quote)
  {
    this._pos++;
  }

  if (this._pos === this._value.length) {
    // Runaway string.
    throw new Error('Unterminated string starting at position ' + firstPos);
  }

  return this._value.substring(firstPos, this._pos++);
};

/**
* Skips specified operator.
*
* @param {string} operatorChar The oeprator to skip.
*/
ConnectionStringParser.prototype._skipOperator = function (operatorChar) {
  var currentChar = this._value[this._pos];

  if (currentChar != operatorChar) {
    // Character was expected.
    throw new Error('expecting ' + operatorChar + ' but instead got ' + currentChar + ' at position ' + this._pos);
  }

  this._pos++;
};

/**
* Extracts key's value.
*
* @return {string} The key value.
*/
ConnectionStringParser.prototype._extractValue = function () {
  var value = '';

  if (this._pos < this._value.length) {
    var ch = this._value[this._pos];

    if (ch === '\'' || ch === '"') {
      this._pos++;
      value = this._extractString(ch);
    } else {
      var firstPos = this._pos;
      var isFound = false;

      while (this._pos < this._value.length && !isFound) {
        ch = this._value[this._pos];

        if (ch === ';') {
          isFound = true;
          break;
        } else {
          this._pos++;
        }
      }

      value = this._value.substring(firstPos, this._pos);
    }
  }

  return value;
};

/**
* Parses a connection string.
*
* @param {number} connectionString The connection string to be parsed.
* @return {object} The connection string object.
*/
exports.parse = function (connectionString, options) {
  var connectionStringParser = new ConnectionStringParser(connectionString);
  return connectionStringParser._parse(options);
};