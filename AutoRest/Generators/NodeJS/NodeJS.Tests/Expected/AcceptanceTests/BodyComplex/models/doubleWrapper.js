'use strict';

/**
 * @class
 * Initializes a new instance of the DoubleWrapper class.
 * @constructor
 */
function DoubleWrapper() { }

/**
 * Validate the payload against the DoubleWrapper schema
 *
 * @param {JSON} payload
 *
 */
DoubleWrapper.prototype.validate = function (payload) {
  if (!payload) {
    throw new Error('DoubleWrapper cannot be null.');
  }
  if (payload['field1'] !== null && payload['field1'] !== undefined && typeof payload['field1'] !== 'number') {
    throw new Error('payload[\'field1\'] must be of type number.');
  }

  if (payload['field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose'] !== null && payload['field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose'] !== undefined && typeof payload['field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose'] !== 'number') {
    throw new Error('payload[\'field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose\'] must be of type number.');
  }
};

/**
 * Deserialize the instance to DoubleWrapper schema
 *
 * @param {JSON} instance
 *
 */
DoubleWrapper.prototype.deserialize = function (instance) {
  return instance;
};

module.exports = new DoubleWrapper();
