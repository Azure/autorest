// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var util = require('util');
var moment = require('moment');
var stream = require('stream');

/**
 * Serializes the JSON Object. It serializes Buffer object to a 
 * 'base64' encoded string and a Date Object to a string 
 * compliant with ISO8601 format.
 * 
 * @param {Object} toSerialize
 * 
 * @returns {Object} serializedObject
 */
exports.serializeObject = function (toSerialize) {
  if (toSerialize === null || toSerialize === undefined) return null;
  if (Buffer.isBuffer(toSerialize)) {
    toSerialize = toSerialize.toString('base64');
    return toSerialize;
  }
  else if (toSerialize instanceof Date) {
    return toSerialize.toISOString();
  }
  else if (Array.isArray(toSerialize)) {
    var array = [];
    for (var i = 0; i < toSerialize.length; i++) {
      array.push(exports.serializeObject.call(this, toSerialize[i]));
    }
    return array;
  } else if (typeof toSerialize === 'object') {
    var dictionary = {};
    for (var property in toSerialize) {
      dictionary[property] = exports.serializeObject.call(this, toSerialize[property]);
    }
    return dictionary;
  }
  return toSerialize;
};

/**
 * Serialize the given object based on its metadata defined in the mapper
 *
 * @param {object} mapper The mapper which defines the metadata of the serializable object
 *
 * @param {object|string|Array|number|boolean|Date|stream} object A valid Javascript object to be serialized
 *
 * @param {string} objectName Name of the serialized object
 *
 * @returns {object|string|Array|number|boolean|Date|stream} A valid serialized Javascript object
 */
exports.serialize = function (mapper, object, objectName) {
  var payload = {};
  var mapperType = mapper.type.name;
  if (!objectName) objectName = objectNameFromSerializedName(mapper.serializedName);
  if (mapperType.match(/^Sequence$/ig) !== null) payload = [];
  //Throw if required and object is null or undefined
  if (mapper.required && (object === null || object === undefined) && !mapper.isConstant) {
    throw new Error(util.format('\'%s\' cannot be null or undefined.'), objectName);
  }
  //Set Defaults
  if (mapper.defaultValue && (object === null || object === undefined)) object = mapper.defaultValue;
  if (mapper.isConstant) object = mapper.defaultValue;
  //Validate Constraints if any
  validateConstraints.call(this, mapper, object, objectName);
  if (mapperType.match(/^(Number|String|Boolean|Object|Stream)$/ig) !== null) {
    payload = serializeBasicTypes.call(this, mapperType, objectName, object);
  } else if (mapperType.match(/^Enum$/ig) !== null) {
    payload = serializeEnumType.call(this, objectName, mapper.type.allowedValues, object);
  } else if (mapperType.match(/^(Date|DateTime|TimeSpan|DateTimeRfc1123)$/ig) !== null) {
    payload = serializeDateTypes.call(this, mapperType, object, objectName);
  } else if (mapperType.match(/^ByteArray$/ig) !== null) {
    payload = serializeBufferType.call(this, objectName, object);
  } else if (mapperType.match(/^Sequence$/ig) !== null) {
    payload = serializeSequenceType.call(this, mapper, object, objectName);
  } else if (mapperType.match(/^Dictionary$/ig) !== null) {
    payload = serializeDictionaryType.call(this, mapper, object, objectName);
  } else if (mapperType.match(/^Composite$/ig) !== null) {
    payload = serializeCompositeType.call(this, mapper, object, objectName);
  }
  return payload;
};

function validateConstraints(mapper, value, objectName) {
  if (mapper.constraints && (value !== null || value !== undefined)) {
    Object.keys(mapper.constraints).forEach(function (constraintType) {
      if (constraintType.match(/^ExclusiveMaximum$/ig) !== null) {
        if (value >= mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'ExclusiveMaximum\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^ExclusiveMinimum$/ig) !== null) {
        if (value <= mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'ExclusiveMinimum\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^InclusiveMaximum$/ig) !== null) {
        if (value > mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'InclusiveMaximum\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^InclusiveMinimum$/ig) !== null) {
        if (value < mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'InclusiveMinimum\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^MaxItems$/ig) !== null) {
        if (value.length > mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'MaxItems\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^MaxLength$/ig) !== null) {
        if (value.length > mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'MaxLength\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^MinItems$/ig) !== null) {
        if (value.length < mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'MinItems\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^MinLength$/ig) !== null) {
        if (value.length < mapper.constraints[constraintType]) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'MinLength\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^MultipleOf$/ig) !== null) {
        if (value.length % mapper.constraints[constraintType] !== 0) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'MultipleOf\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^Pattern$/ig) !== null) {
        if (value.match(mapper.constraints[constraintType].split('/').join('\/')) === null) {
          throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'Pattern\': %s.', 
          objectName, value, mapper.constraints[constraintType]));
        }
      } else if (constraintType.match(/^UniqueItems/ig) !== null) {
        if (mapper.constraints[constraintType]) {
          if (value.length !== value.filter(function (item, i, ar) { { return ar.indexOf(item) === i; } }).length) {
            throw new Error(util.format('\'%s\' with value \'%s\' should satify the constraint \'UniqueItems\': %s', 
          objectName, value, mapper.constraints[constraintType]));
          }
        }
      }
    });
  }
}

function serializeSequenceType(mapper, object, objectName) {
  /*jshint validthis: true */
  if (!util.isArray(object)) {
    throw new Error(util.format('%s must be of type Array', objectName));
  }
  if (!mapper.type.element || typeof mapper.type.element !== 'object') {
    throw new Error(util.format('\'element\' metadata for an Array must be defined in the ' + 
      'mapper and it must of type \'object\' in %s', objectName));
  }
  var tempArray = [];
  for (var i = 0; i < object.length; i++) {
    tempArray[i] = exports.serialize.call(this, mapper.type.element, object[i], objectName);
  }
  return tempArray;
}

function serializeDictionaryType(mapper, object, objectName) {
  /*jshint validthis: true */
  if (typeof object !== 'object') {
    throw new Error(util.format('%s must be of type object', objectName));
  }
  if (!mapper.type.value || typeof mapper.type.value !== 'object') {
    throw new Error(util.format('\'value\' metadata for a Dictionary must be defined in the ' + 
      'mapper and it must of type \'object\' in %s', objectName));
  }
  var tempDictionary = {};
  for (var key in object) {
    if (object.hasOwnProperty(key)) {
      tempDictionary[key] = exports.serialize.call(this, mapper.type.value, object[key], objectName);
    }
  }
  return tempDictionary;
}

function serializeCompositeType(mapper, object, objectName) {
  /*jshint validthis: true */
  //check for polymorphic discriminator
  if (mapper.type.polymorphicDiscriminator) {
    if (object === null || object === undefined) {
      throw new Error(util.format('\'%s\' cannot be null or undefined. \'%s\' is the ' + 
        'polmorphicDiscriminator and is a required property.', objectName, 
        mapper.type.polymorphicDiscriminator));
    }
    if (!object[mapper.type.polymorphicDiscriminator]) {
      throw new Error(util.format('No discriminator field \'%s\' was found in \'%s\'.', 
        mapper.type.polymorphicDiscriminator, objectName));
    }
    if (!this.models.discriminators[object[mapper.type.polymorphicDiscriminator]]) {
      throw new Error(util.format('\'%s\': \'%s\'  in \'%s\' is not a valid ' + 
        'discriminator as a corresponding model class for that value was not found.', 
        mapper.type.polymorphicDiscriminator, object[mapper.type.polymorphicDiscriminator], objectName));
    }
    mapper = new this.models.discriminators[object[mapper.type.polymorphicDiscriminator]]().mapper();
  }
  
  var payload = {};
  var modelMapper = {};
  var mapperType = mapper.type.name;
  if (mapperType === 'Sequence') payload = [];
  if (object !== null && object !== undefined) {
    var modelProps = mapper.type.modelProperties;
    if (!modelProps) {
      if (!mapper.type.className) {
        throw new Error(util.format('Class name for model \'%s\' is not provided in the mapper \'%s\'',
            objectName, JSON.stringify(mapper)));
      }
      //get the mapper if modelProperties of the CompositeType is not present and 
      //then get the modelProperties from it.
      modelMapper = new this.models[mapper.type.className]().mapper();
      if (!modelMapper) {
        throw new Error(util.format('mapper() cannot be null or undefined for model \'%s\'', 
              mapper.type.className));
      }
      modelProps = modelMapper.type.modelProperties;
      if (!modelProps) {
        throw new Error(util.format('modelProperties cannot be null or undefined in the ' + 
          'mapper \'%s\' of type \'%s\' for object \'%s\'.', JSON.stringify(modelMapper), 
          mapper.type.className, objectName));
      }
    }
    
    if (requiresFlattening(modelProps, object) && !payload.properties) payload.properties = {};
    for (var key in modelProps) {
      if (modelProps.hasOwnProperty(key)) {
        //make sure required properties of the CompositeType are present
        if (modelProps[key].required) {
          if (object[key] === null || object[key] === undefined) {
            throw new Error(util.format('\'%s\' cannot be null or undefined in \'%s\'.', key, objectName));
          }
        }
        //serialize the property if it is present in the provided object instance
        if (modelProps[key].isConstant || (object[key] !== null && object[key] !== undefined)) {
          var propertyObjectName = objectName + '.' + objectNameFromSerializedName(modelProps[key].serializedName);
          var propertyMapper = modelProps[key];
          var serializedValue = exports.serialize.call(this, propertyMapper, object[key], propertyObjectName);
          assignProperty(modelProps[key].serializedName, payload, serializedValue);
        }
      }
    }
    return payload;
  }
  return object;
}

function serializeBasicTypes(typeName, objectName, value) {
  if (value !== null && value !== undefined) {
    if (typeName.match(/^Number$/ig) !== null) {
      if (typeof value !== 'number') {
        throw new Error(util.format('%s must be of type number.', objectName));
      }
    } else if (typeName.match(/^String$/ig) !== null) {
      if (typeof value.valueOf() !== 'string') {
        throw new Error(util.format('%s must be of type string.', objectName));
      }
    } else if (typeName.match(/^Boolean$/ig) !== null) {
      if (typeof value !== 'boolean') {
        throw new Error(util.format('%s must be of type boolean.', objectName));
      }
    } else if (typeName.match(/^Object$/ig) !== null) {
      if (typeof value !== 'object') {
        throw new Error(util.format('%s must be of type object.', objectName));
      }
    }  else if (typeName.match(/^Stream$/ig) !== null) {
      if (value instanceof stream.Stream) {
        throw new Error(util.format('%s must be of type stream.', objectName));
      }
    }
  }
  return value;
}

function serializeEnumType(objectName, allowedValues, value) {
  if (!allowedValues) {
    throw new Error(util.format('Please provide a set of allowedValues to validate %s as an Enum Type.', objectName));
  }
  if (!allowedValues.some(function (item) { return item === value; })) {
    throw new Error(util.format('%s is not a valid value for %s. The valid values are: %s', 
      value, objectName, JSON.stringify(allowedValues)));
  }
  return value;
}

function serializeBufferType(objectName, value) {
  if (value !== null && value !== undefined) {
    if (!Buffer.isBuffer(value)) {
      throw new Error(util.format('%s must be of type Buffer.', objectName));
    }
    value = value.toString('base64');
  }
  return value;
}

function serializeDateTypes(typeName, value, objectName) {
  if (value !== null && value !== undefined) {
    if (typeName.match(/^Date$/ig) !== null) {
      if (!(value instanceof Date || 
        (typeof value.valueOf() === 'string' && !isNaN(Date.parse(value))))) {
        throw new Error(util.format('%s must be an instanceof Date or a string in ISO8601 format.', objectName));
      }
      value = (value instanceof Date) ? value.toISOString().substring(0, 10) : new Date(value).toISOString().substring(0, 10);
    } else if (typeName.match(/^DateTime$/ig) !== null) {
      if (!(value instanceof Date || 
        (typeof value.valueOf() === 'string' && !isNaN(Date.parse(value))))) {
        throw new Error(util.format('%s must be an instanceof Date or a string in ISO8601 format.', objectName));
      }
      value = (value instanceof Date) ? value.toISOString() :  new Date(value).toISOString();
    } else if (typeName.match(/^DateTimeRfc1123$/ig) !== null) {
      if (!(value instanceof Date || 
        (typeof value.valueOf() === 'string' && !isNaN(Date.parse(value))))) {
        throw new Error(util.format('%s must be an instanceof Date or a string in RFC-1123 format.', objectName));
      }
      value = (value instanceof Date) ? value.toUTCString() :  new Date(value).toUTCString();
    } else if (typeName.match(/^TimeSpan$/ig) !== null) {
      if (!moment.isDuration(value)) {
        throw new Error(util.format('%s must be a TimeSpan/Duration.', objectName));
      }
      value = value.toISOString();
    }
  }
  return value;
}

/**
 * Deserialize the given object based on its metadata defined in the mapper
 *
 * @param {object} mapper The mapper which defines the metadata of the serializable object
 *
 * @param {object|string|Array|number|boolean|Date|stream} responseBody A valid Javascript entity to be deserialized
 *
 * @param {string} objectName Name of the deserialized object
 *
 * @returns {object|string|Array|number|boolean|Date|stream} A valid deserialized Javascript object
 */
exports.deserialize = function (mapper, responseBody, objectName) {
  if (responseBody === null || responseBody === undefined) return responseBody;
  var payload = {};
  var mapperType = mapper.type.name;
  if (!objectName) objectName = objectNameFromSerializedName(mapper.serializedName);
  if (mapperType.match(/^Sequence$/ig) !== null) payload = [];
  
  if (mapperType.match(/^(Number|String|Boolean|Enum|Object|Stream)$/ig) !== null) {
    payload = responseBody;
  } else if (mapperType.match(/^(Date|DateTime|DateTimeRfc1123)$/ig) !== null) {
    payload = new Date(responseBody);
  } else if (mapperType.match(/^(TimeSpan)$/ig) !== null) {
    payload = moment.duration(responseBody);
  } else if (mapperType.match(/^ByteArray$/ig) !== null) {
    payload = new Buffer(responseBody, 'base64');
  } else if (mapperType.match(/^Sequence$/ig) !== null) {
    payload = deserializeSequenceType.call(this, mapper, responseBody, objectName);
  } else if (mapperType.match(/^Dictionary$/ig) !== null) {
    payload = deserializeDictionaryType.call(this, mapper, responseBody, objectName);
  } else if (mapperType.match(/^Composite$/ig) !== null) {
    payload = deserializeCompositeType.call(this, mapper, responseBody, objectName);
  }

  if (mapper.isConstant) payload = mapper.defaultValue;
  
  return payload;
};

function deserializeSequenceType(mapper, responseBody, objectName) {
  /*jshint validthis: true */
  if (!mapper.type.element || typeof mapper.type.element !== 'object') {
    throw new Error(util.format('\'element\' metadata for an Array must be defined in the ' + 
      'mapper and it must of type \'object\' in %s', objectName));
  }
  if (responseBody) {
    var tempArray = [];
    for (var i = 0; i < responseBody.length; i++) {
      tempArray[i] = exports.deserialize.call(this, mapper.type.element, responseBody[i], objectName);
    }
    return tempArray;
  }
  return responseBody;
}

function deserializeDictionaryType(mapper, responseBody, objectName) {
  /*jshint validthis: true */
  if (!mapper.type.value || typeof mapper.type.value !== 'object') {
    throw new Error(util.format('\'value\' metadata for a Dictionary must be defined in the ' + 
      'mapper and it must of type \'object\' in %s', objectName));
  }
  if (responseBody) {
    var tempDictionary = {};
    for (var key in responseBody) {
      if (responseBody.hasOwnProperty(key)) {
        tempDictionary[key] = exports.deserialize.call(this, mapper.type.value, responseBody[key], objectName);
      }
    }
    return tempDictionary;
  }
  return responseBody;
}

function deserializeCompositeType(mapper, responseBody, objectName) {
  /*jshint validthis: true */
  //check for polymorphic discriminator
  if (mapper.type.polymorphicDiscriminator) {
    if (responseBody === null || responseBody === undefined) {
      throw new Error(util.format('\'%s\' cannot be null or undefined. \'%s\' is the ' + 
        'polmorphicDiscriminator and is a required property.', objectName, 
        mapper.type.polymorphicDiscriminator));
    }
    if (!responseBody[mapper.type.polymorphicDiscriminator]) {
      throw new Error(util.format('No discriminator field \'%s\' was found in \'%s\'.', 
        mapper.type.polymorphicDiscriminator, objectName));
    }
    if (!this.models.discriminators[responseBody[mapper.type.polymorphicDiscriminator]]) {
      throw new Error(util.format('\'%s\': \'%s\'  in \'%s\' is not a valid ' + 
        'discriminator as a corresponding model class for that value was not found.', 
        mapper.type.polymorphicDiscriminator, responseBody[mapper.type.polymorphicDiscriminator], objectName));
    }
    mapper = new this.models.discriminators[responseBody[mapper.type.polymorphicDiscriminator]]().mapper();
  }
  
  var instance = {};
  var modelMapper = {};
  var mapperType = mapper.type.name;
  if (mapperType === 'Sequence') instance = [];
  if (responseBody !== null && responseBody !== undefined) {
    var modelProps = mapper.type.modelProperties;
    if (!modelProps) {
      if (!mapper.type.className) {
        throw new Error(util.format('Class name for model \'%s\' is not provided in the mapper \'%s\'',
            objectName, JSON.stringify(mapper)));
      }
      //get the mapper if modelProperties of the CompositeType is not present and 
      //then get the modelProperties from it.
      modelMapper = new this.models[mapper.type.className]().mapper();
      if (!modelMapper) {
        throw new Error(util.format('mapper() cannot be null or undefined for model \'%s\'', 
              mapper.type.className));
      }
      modelProps = modelMapper.type.modelProperties;
      if (!modelProps) {
        throw new Error(util.format('modelProperties cannot be null or undefined in the ' + 
          'mapper \'%s\' of type \'%s\' for responseBody \'%s\'.', JSON.stringify(modelMapper), 
          mapper.type.className, objectName));
      }
    }
    
    for (var key in modelProps) {
      if (modelProps.hasOwnProperty(key)) {
        //deserialize the property if it is present in the provided responseBody instance
        var propertyInstance = responseBody[modelProps[key].serializedName];
        if (stringContainsProperties(modelProps[key].serializedName)) {
          if (responseBody.properties) {
            var serializedKey = objectNameFromSerializedName(modelProps[key].serializedName);
            propertyInstance = responseBody.properties[serializedKey];
          }
        }
        var propertyObjectName = objectName + '.' + modelProps[key].serializedName;
        var propertyMapper = modelProps[key];
        var serializedValue;
        //paging
        if (key === 'value' && util.isArray(responseBody[key]) && modelProps[key].serializedName === '') {
          propertyInstance = responseBody[key];
          instance = exports.deserialize.call(this, propertyMapper, propertyInstance, propertyObjectName);
        } else if (propertyInstance !== null && propertyInstance !== undefined) {
          serializedValue = exports.deserialize.call(this, propertyMapper, propertyInstance, propertyObjectName);
          instance[key] = serializedValue;
        }
      }
    }
    return instance;
  }
  return responseBody;
}

function assignProperty(serializedName, payload, serializedValue) {
  var key = objectNameFromSerializedName(serializedName);
  if (stringContainsProperties(serializedName)) {
    payload.properties[key] = serializedValue;
  } else {
    payload[key] = serializedValue;
  }
}

function requiresFlattening(mapper, object) {
  return Object.keys(mapper).some(function (key) {
    return ((mapper[key].serializedName.match(/^properties\./ig) !== null) && 
            (object[key] !== null && object[key] !== undefined));
  });
}

function objectNameFromSerializedName(name) {
  if (stringContainsProperties(name)) {
    return name.match(/^properties\.(\w+)$/i)[1];
  }
  return name;
}

function stringContainsProperties(prop) {
  return (prop.match(/^properties\.(\w+)$/i) !== null);
}

exports = module.exports;