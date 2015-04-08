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

/**
*
* Validates that a clusterCreationObject is properly formed.
*
* @param {object} clusterCreationObject             The object used to supply all parameters needed to create a cluster.
*                                                   {
*                                                     // the following are required fields
*                                                     name: 'the name of the cluster (dns name) all lower case',
*                                                     location: 'the Azure data center where the cluster is to be created',
*                                                     defaultStorageAccountName: 'The name of the default Azure storage account',
*                                                     defaultStorageAccountKey: 'The secret key for the default Azure storage account',
*                                                     defaultStorageContainer: 'The container for the default Azure storage account',
*                                                     user: 'The username to use for the cluster',
*                                                     password: 'The password to use for the cluster',
*                                                     nodes: number // The number of nodes to use
*                                                     // the following are optional fields
*                                                     additionalStorageAccounts : [ {
*                                                         name: 'the name of the storage acount'
*                                                         key: 'the secret key for the storage acount'
*                                                       }, { // additional accounts following the same pattern }
*                                                     ]
*                                                     // the following are optional but if one is specified the other is required
*                                                     oozieMetastore : {
*                                                       server : 'the name of the sql server to use',
*                                                       database : 'the sql databse to use'
*                                                       user : 'the user name to use when logging into the database'
*                                                       password : 'the password to use when logging into the database'
*                                                     }
*                                                     hiveMetastore : {
*                                                       server : 'the name of the sql server to use',
*                                                       database : 'the sql databse to use'
*                                                       user : 'the user name to use when logging into the database'
*                                                       password : 'the password to use when logging into the database'
*                                                     }
*                                                   }
*/
exports.isValidHDInsightCreationObject = function (clusterCreationObject, callback) {
  var fail;
  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (typeof(clusterCreationObject.name) != 'string') {
    return fail('The [name] field is required when creating a cluster and must be a string');
  }
  if (typeof(clusterCreationObject.location) != 'string') {
    return fail('The [location] field is required when creating a cluster and must be a string');
  }
  if (typeof(clusterCreationObject.defaultStorageAccountName) != 'string') {
    return fail('The [defaultStorageAccountName] field is required when creating a cluster and must be a string');
  }
  if (typeof(clusterCreationObject.defaultStorageAccountKey) != 'string') {
    return fail('The [defaultStorageAccountKey] field is required when creating a cluster and must be a string');
  }
  if (typeof(clusterCreationObject.defaultStorageContainer) != 'string') {
    return fail('The [defaultStorageContainer] field is required when creating a cluster and must be a string');
  }
  if (!this.containerNameIsValid(clusterCreationObject.defaultStorageContainer, function() {})) {
    return fail('The [defaultStorageContainer] field is required when creating a cluster and must be a valid storage container name');
  }
  if (typeof(clusterCreationObject.user) != 'string') {
    return fail('The [user] field is required when creating a cluster and must be a string');
  }
  if (typeof(clusterCreationObject.password) != 'string') {
    return fail('The [password] field is required when creating a cluster and must be a string');
  }
  if (typeof(clusterCreationObject.nodes) != 'number' || !azureutil.isInt(clusterCreationObject.nodes)) {
    return fail('The [nodes] field is required when creating a cluster and must be an integer');
  }
  if (clusterCreationObject.additionalStorageAccounts) {
    if (!_.isArray(clusterCreationObject.additionalStorageAccounts)) {
      return fail('The [additionalStorageAccounts] field is optional when creating a cluster but must be an array when specified');
    }
    for (var i = 0; i < clusterCreationObject.additionalStorageAccounts.length; i++) {
      var account = clusterCreationObject.additionalStorageAccounts[i];
      if (typeof(account.name) != 'string') {
        return fail('The [additionalStorageAccounts] field is optional but if supplied each element must have a [name] field and it must be a string. Element ' + i + ' does not have a [name] field or it is not a string');
      }
      if (typeof(account.key) != 'string') {
        return fail('The [additionalStorageAccounts] field is optional but if supplied each element must have a [key] field and it must be a string. Element ' + i + ' does not have a [key] field or it is not a string');
      }
    }
  }
  if (clusterCreationObject.oozieMetastore) {
    if (!clusterCreationObject.hiveMetastore) {
      return fail('If the [oozieMetastore] field is supplied, than the [hiveMetastore] field must also be supplied');
    }
    if (typeof(clusterCreationObject.oozieMetastore.server) != 'string') {
      return fail('If the [oozieMetastore] field is supplied it must contain a [server] field which must be a string');
    }
    if (typeof(clusterCreationObject.oozieMetastore.database) != 'string') {
      return fail('If the [oozieMetastore] field is supplied it must contain a [database] field which must be a string');
    }
    if (typeof(clusterCreationObject.oozieMetastore.user) != 'string') {
      return fail('If the [oozieMetastore] field is supplied it must contain a [user] field which must be a string');
    }
    if (typeof(clusterCreationObject.oozieMetastore.password) != 'string') {
      return fail('If the [oozieMetastore] field is supplied it must contain a [password] field which must be a string');
    }
  }
  if (clusterCreationObject.hiveMetastore) {
    if (!clusterCreationObject.oozieMetastore) {
      return fail('If the [hiveMetastore] field is supplied, than the [oozieMetastore] field must also be supplied');
    }
    if (typeof(clusterCreationObject.hiveMetastore.server) != 'string') {
      return fail('If the [hiveMetastore] field is supplied it must contain a [server] field which must be a string');
    }
    if (typeof(clusterCreationObject.hiveMetastore.database) != 'string') {
      return fail('If the [hiveMetastore] field is supplied it must contain a [database] field which must be a string');
    }
    if (typeof(clusterCreationObject.hiveMetastore.user) != 'string') {
      return fail('If the [hiveMetastore] field is supplied it must contain a [user] field which must be a string');
    }
    if (typeof(clusterCreationObject.hiveMetastore.password) != 'string') {
      return fail('If the [hiveMetastore] field is supplied it must contain a [password] field which must be a string');
    }
  }
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
* Creates a anonymous function that check if a given key is base 64 encoded.
*
* @param {string} key The key to validate.
* @return {function}
*/
exports.isBase64Encoded = function (key) {
  var isValidBase64String = key.match('^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$');

  if (isValidBase64String) {
    return true;
  } else {
    throw new Error('The provided account key ' + key + ' is not a valid base64 string.');
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

/**
* Validates that a Service Bus namespace name
* is legally allowable. Does not check availability.
*
* @param {string} name the name to check
*
* @return nothing. Throws exception if name is invalid, message
*                  describes what validity criteria it violates.
*/

exports.namespaceNameIsValid = function (name, callback) {
  var validNameRegex = /^[a-zA-Z][a-zA-Z0-9\-]*$/;
  var illegalEndings = /(-|-sb|-mgmt|-cache|-appfabric)$/;

  var fail;
  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (name.length < 6 || name.length > 50) {
    return fail('Service Bus namespace names must be 6 to 50 characters long.');
  }
  if (!validNameRegex.test(name)) {
    return fail('Service Bus namespace names must start with a letter and include only letters, digits, and hyphens');
  }
  if (illegalEndings.test(name)) {
    return fail('Service Bus namespace names may not end with "-", "-sb", "-mgmt", "-cache", or "-appfabric"');
  }

  callback();
  return true;
};

/**
* Validates a container name.
*
* @param {string} containerName The container name.
* @return {undefined}
*/
exports.containerNameIsValid = function (containerName, callback) {
  var fail;
  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (!azureutil.objectIsString(containerName) || azureutil.stringIsEmpty(containerName)) {
    return fail('Container name must be a non empty string.');
  }

  if (containerName === '$root' || containerName === '$logs') {
    callback();
    return true;
  }

  if (containerName.match('^[a-z0-9][a-z0-9-]*$') === null) {
    return fail('Container name format is incorrect.');
  }

  if (containerName.indexOf('--') !== -1) {
    return fail('Container name format is incorrect.');
  }

  if (containerName.length < 3 || containerName.length > 63) {
    return fail('Container name format is incorrect.');
  }

  if (containerName.substr(containerName.length - 1, 1) === '-') {
    return fail('Container name format is incorrect.');
  }

  callback();
  return true;
};

/**
* Validates a blob name.
*
* @param {string} containerName The container name.
* @param {string} blobname      The blob name.
* @return {undefined}
*/
exports.blobNameIsValid = function (containerName, blobName, callback) {
  var fail;

  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (!blobName) {
    return fail( 'Blob name is not specified.');
  }

  if (containerName === '$root' && blobName.indexOf('/') !== -1) {
    return fail('Blob name format is incorrect.');
  }

  callback();
  return true;
};

/**
* Validates a table name.
*
* @param {string} table  The table name.
* @return {undefined}
*/
exports.tableNameIsValid = function (name, callback) {
  var fail;

  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (!azureutil.objectIsString(name) || azureutil.stringIsEmpty(name)) {
    return fail('Table name must be a non empty string.');
  }

  callback();
  return true;
};

exports.pageRangesAreValid = function (rangeStart, rangeEnd, writeBlockSizeInBytes, callback) {
  var fail;

  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (rangeStart % 512 !== 0) {
    return fail('Start byte offset must be a modulus of 512.');
  }

  var size = null;
  if (!azureutil.objectIsNull(rangeEnd)) {
    if ((rangeEnd + 1) % 512 !== 0) {
      return fail('End byte offset must be a modulus of 512 minus 1.');
    }

    size = (rangeEnd - rangeStart) + 1;
    if (size > this.writeBlockSizeInBytes) {
      return fail('Page blob size cant be larger than ' + writeBlockSizeInBytes + ' bytes.');
    }
  }

  callback();
  return true;
};

/**
* Validates a queue name.
*
* @param {string} queue The queue name.
* @return {undefined}
*/
exports.queueNameIsValid = function (queue, callback) {
  var fail;

  initCallback(callback, function (f, cb) {
    fail = f;
    callback = cb;
  });

  if (!azureutil.objectIsString(queue) || azureutil.stringIsEmpty(queue)) {
    return fail('Queue name must be a non empty string.');
  }

  if (queue === '$root') {
    return true;
  }

  // Caps aren't allowed by the REST API
  if (queue.match('^[a-z0-9][a-z0-9-]*$') === null) {
    return fail('Incorrect queue name format.');
  }

  if (queue.indexOf('--') !== -1) {
    return fail('Incorrect queue name format.');
  }

  if (queue.length < 3 || queue.length > 63) {
    return fail('Incorrect queue name format.');
  }

  if (queue.substr(queue.length - 1, 1) === '-') {
    return fail('Incorrect queue name format.');
  }

  callback();
  return true;
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

  tableNameIsValid: exports.tableNameIsValid,
  containerNameIsValid: exports.containerNameIsValid,
  blobNameIsValid: exports.blobNameIsValid,
  pageRangesAreValid: exports.pageRangesAreValid,
  queueNameIsValid: exports.queueNameIsValid
});

function validateArgs(functionName, validationRules) {
  var validator = new ArgumentValidator(functionName);
  validationRules(validator);
}

exports.ArgumentValidator = ArgumentValidator;
exports.validateArgs = validateArgs;