// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

var _ = require('underscore');
var check = require('validator');

exports = module.exports;

function initCallback(callbackParam, resultsCb) {
  var fail;
  if (callbackParam) {
    fail = function (err) {
      callbackParam(new Error(err));
      return false;
    };
  } else {
    fail = function (err) {
      throw new Error(err);
    };
    callbackParam = function () {};
  }

  resultsCb(fail, callbackParam);
}

/**
* Creates a anonymous function that check if the given uri is valid or not.
*
* @param {string} uri The uri to validate.
* @return {function}
*/
exports.isValidUri = function (uri) {
  if (!check.isURL(uri)){
    throw new Error('The provided URI "' + uri + '" is invalid.');
  }
  return true;
};

exports.isValidUuid = function(uuid, callback) {
  var validUuidRegex = /^[a-zA-Z0-9]{8}\-[a-zA-Z0-9]{4}\-[a-zA-Z0-9]{4}\-[a-zA-Z0-9]{4}\-[a-zA-Z0-9]{12}$/;

  var fail;

  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (!validUuidRegex.test(uuid)) {
    return fail('The value is not a valid UUID format.');
  }
};

/**
* Validates a function.
*
* @param {object} function The function to validate.
* @return {function}
*/
exports.isValidFunction = function (functionObject, functionName) {
  if (!functionObject || !_.isFunction(functionObject)) {
    throw new Error(functionName + ' must be specified.');
  }
};


// common functions for validating arguments

function throwMissingArgument(name, func) {
  throw new Error('Required argument ' + name + ' for function ' + func + ' is not defined');
}

function ArgumentValidator(functionName) {
  this.func = functionName;
}

_.extend(ArgumentValidator.prototype, {
  string: function (val, name) {
    if (typeof val != 'string' || val.length === 0) {
      throwMissingArgument(name, this.func);
    }
  },

  object: function (val, name) {
    if (!val) {
      throwMissingArgument(name, this.func);
    }
  },

  exists: function (val, name) {
    this.object(val, name);
  },

  function: function (val, name) {
    if (typeof val !== 'function') {
      throw new Error('Parameter ' + name + ' for function ' + this.func + ' should be a function but is not');
    }
  },

  value: function (val, name) {
    if (!val) {
      throwMissingArgument(name, this.func);
    }
  },

  nonEmptyArray: function (val, name) {
    if (!val || val.length === 0) {
      throw new Error('Required array argument ' + name + ' for function ' + this.func + ' is either not defined or empty');
    }
  },

  callback: function (val) {
    this.object(val, 'callback');
    this.function(val, 'callback');
  },

  test: function (predicate, message) {
    if (!predicate()) {
      throw new Error(message + ' in function ' + this.func);
    }
  },
});

function validateArgs(functionName, validationRules) {
  var validator = new ArgumentValidator(functionName);
  validationRules(validator);
}

exports.ArgumentValidator = ArgumentValidator;
exports.validateArgs = validateArgs;