// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

'use strict';

var util = require('util');
var moment = require('moment');
var stream = require('stream');
var utils = require('./utils');

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
  if (!objectName) objectName = mapper.serializedName;
  if (mapperType.match(/^Sequence$/ig) !== null) payload = [];
  //Throw if required and object is null or undefined
  if (mapper.required && (object === null || object === undefined) && !mapper.isConstant) {
    throw new Error(util.format('\'%s\' cannot be null or undefined.', objectName));
  }
  //Set Defaults
  if ((mapper.defaultValue !== null && mapper.defaultValue !== undefined) && 
      (object === null || object === undefined)) {
    object = mapper.defaultValue;
  }
  if (mapper.isConstant) object = mapper.defaultValue;
  //Validate Constraints if any
  validateConstraints.call(this, mapper, object, objectName);
  if (mapperType.match(/^(Number|String|Boolean|Object|Stream|Uuid)$/ig) !== null) {
    payload = serializeBasicTypes.call(this, mapperType, objectName, object);
  } else if (mapperType.match(/^Enum$/ig) !== null) {
    payload = serializeEnumType.call(this, objectName, mapper.type.allowedValues, object);
  } else if (mapperType.match(/^(Date|DateTime|TimeSpan|DateTimeRfc1123|UnixTime)$/ig) !== null) {
    payload = serializeDateTypes.call(this, mapperType, object, objectName);
  } else if (mapperType.match(/^ByteArray$/ig) !== null) {
    payload = serializeBufferType.call(this, objectName, object);
  } else if (mapperType.match(/^Base64Url$/ig) !== null) {
    payload = serializeBase64UrlType.call(this, objectName, object);
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
    mapper = getPolymorphicMapper.call(this, mapper, object, objectName, 'serialize');
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
    
    for (var key in modelProps) {
      if (modelProps.hasOwnProperty(key)) {
        var paths = splitSerializeName(modelProps[key].serializedName);
        var propName = paths.pop();

        var parentObject = payload;
        paths.forEach(function(pathName) {
           var childObject = parentObject[pathName];
           if ((childObject === null || childObject === undefined) && (object[key] !== null && object[key] !== undefined)) {
            parentObject[pathName] = {};
           }
           parentObject = parentObject[pathName];
        });

        //make sure required properties of the CompositeType are present
        if (modelProps[key].required && !modelProps[key].isConstant) {
          if (object[key] === null || object[key] === undefined) {
            throw new Error(util.format('\'%s\' cannot be null or undefined in \'%s\'.', key, objectName));
          }
        }
        //make sure that readOnly properties are not sent on the wire
        if (modelProps[key].readOnly) {
          continue;
        }
        //serialize the property if it is present in the provided object instance
        if (((parentObject !== null && parentObject !== undefined) && (modelProps[key].defaultValue !== null && modelProps[key].defaultValue !== undefined)) || 
            (object[key] !== null && object[key] !== undefined)) {
          var propertyObjectName = objectName;
          if (modelProps[key].serializedName !== '') propertyObjectName = objectName + '.' + modelProps[key].serializedName;
          var propertyMapper = modelProps[key];
          var serializedValue = exports.serialize.call(this, propertyMapper, object[key], propertyObjectName);
          parentObject[propName] = serializedValue;
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
        throw new Error(util.format('%s with value %s must be of type number.', objectName, value));
      }
    } else if (typeName.match(/^String$/ig) !== null) {
      if (typeof value.valueOf() !== 'string') {
        throw new Error(util.format('%s with value \'%s\' must be of type string.', objectName, value));
      }
    } else if (typeName.match(/^Uuid$/ig) !== null) {
      if (!(typeof value.valueOf() === 'string' && utils.isValidUuid(value))) {
        throw new Error(util.format('%s with value \'%s\' must be of type string and a valid uuid.', objectName, value));
      }
    } else if (typeName.match(/^Boolean$/ig) !== null) {
      if (typeof value !== 'boolean') {
        throw new Error(util.format('%s with value %s must be of type boolean.', objectName, value));
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
  var isPresent = allowedValues.some(function (item) {
    if (typeof item.valueOf() === 'string') {
      return item.toLowerCase() === value.toLowerCase();
    }
     return item === value;
  });
  if (!isPresent) {
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

function serializeBase64UrlType(objectName, value) {
  if (value !== null && value !== undefined) {
    if (!Buffer.isBuffer(value)) {
      throw new Error(util.format('%s must be of type Buffer.', objectName));
    }
    value = bufferToBase64Url(value);
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
    } else if (typeName.match(/^UnixTime$/ig) !== null) {
      if (!(value instanceof Date || 
        (typeof value.valueOf() === 'string' && !isNaN(Date.parse(value))))) {
        throw new Error(util.format('%s must be an instanceof Date or a string in RFC-1123/ISO8601 format ' + 
          'for it to be serialized in UnixTime/Epoch format.', objectName));
      }
      value = dateToUnixTime(value);
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
  if (!objectName) objectName = mapper.serializedName;
  if (mapperType.match(/^Sequence$/ig) !== null) payload = [];
  
  if (mapperType.match(/^(Number|String|Boolean|Enum|Object|Stream|Uuid)$/ig) !== null) {
    payload = responseBody;
  } else if (mapperType.match(/^(Date|DateTime|DateTimeRfc1123)$/ig) !== null) {
    payload = new Date(responseBody);
  } else if (mapperType.match(/^TimeSpan$/ig) !== null) {
    payload = moment.duration(responseBody);
  } else if (mapperType.match(/^UnixTime$/ig) !== null) {
    payload = unixTimeToDate(responseBody);
  } else if (mapperType.match(/^ByteArray$/ig) !== null) {
    payload = new Buffer(responseBody, 'base64');
  } else if (mapperType.match(/^Base64Url$/ig) !== null) {
    payload = base64UrlToBuffer(responseBody);
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
    mapper = getPolymorphicMapper.call(this, mapper, responseBody, objectName, 'deserialize');
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

        var jpath = ['responseBody'];
        var paths = splitSerializeName(modelProps[key].serializedName);
        paths.forEach(function(item){
            jpath.push(util.format('[\'%s\']', item));
        });
        //deserialize the property if it is present in the provided responseBody instance
        var propertyInstance;
        try {
          /*jslint evil: true */
          propertyInstance = eval(jpath.join(''));
        } catch (err) {
          continue;
        }
        var propertyObjectName = objectName;
        if (modelProps[key].serializedName !== '') propertyObjectName = objectName + '.' + modelProps[key].serializedName;
        var propertyMapper = modelProps[key];
        var serializedValue;
        //paging
        if (util.isArray(responseBody[key]) && modelProps[key].serializedName === '') {
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

function splitSerializeName(prop) {
  var classes = []; 
  var partialclass = ''; 
  var subwords = prop.split('.');

  subwords.forEach(function(item) {
    if (item.charAt(item.length - 1) === '\\') {
     partialclass += item.substr(0, item.length - 1) + '.'; 
    } else {
     partialclass += item;
     classes.push(partialclass);
     partialclass = '';
    }
  });

  return classes;
}

function getPolymorphicMapper(mapper, object, objectName, mode) {
  /*jshint validthis: true */
  //check for polymorphic discriminator
  //Until version 1.15.1, 'polymorphicDiscriminator' in the mapper was a string. This method was not effective when the 
  //polymorphicDiscriminator property had a dot in it's name. So we have comeup with a desgin where polymorphicDiscriminator  
  //will be an object that contains the clientName (normalized property name, ex: 'odatatype') and 
  //the serializedName (ex: 'odata.type') (We do not escape the dots with double backslash in this case as it is not required). 
  //Thus when serializing, the user will give us an object which will contain the normalizedProperty hence we will lookup
  //the clientName of the polmorphicDiscriminator in the mapper and during deserialization from the responseBody we will 
  //lookup the serializedName of the polmorphicDiscriminator in the mapper. This will help us in selecting the correct mapper
  //for the model that needs to be serializes or deserialized. 
  //We need this routing for backwards compatibility. This will absorb the breaking change in the mapper and allow new versions
  //of the runtime to work seamlessly with older version (>= 0.17.0-Nightly20161008) of Autorest generated node.js clients.
  if (mapper.type.polymorphicDiscriminator) {
    if (typeof mapper.type.polymorphicDiscriminator.valueOf() === 'string') {
      return _getPolymorphicMapperStringVersion.call(this, mapper, object, objectName);
    } else if (mapper.type.polymorphicDiscriminator instanceof Object) {
      return _getPolymorphicMapperObjectVersion.call(this, mapper, object, objectName, mode);
    } else {
      throw new Error(util.format('The polymorphicDiscriminator for \'%s\' is neither a string nor an object.', objectName));
    }
  }
  return mapper;
}

//processes new version of the polymorphicDiscriminator in the mapper.
function _getPolymorphicMapperObjectVersion(mapper, object, objectName, mode) {
  /*jshint validthis: true */
  //check for polymorphic discriminator
  var polymorphicPropertyName = '';
  if (mode === 'serialize') {
    polymorphicPropertyName = 'clientName';
  } else if (mode === 'deserialize') {
    polymorphicPropertyName = 'serializedName';
  } else {
    throw new Error(util.format('The given mode \'%s\' for getting the polymorphic mapper for \'%s\' is inavlid.', mode, objectName));
  }

  if (mapper.type.polymorphicDiscriminator && 
      mapper.type.polymorphicDiscriminator[polymorphicPropertyName] !== null && 
      mapper.type.polymorphicDiscriminator[polymorphicPropertyName] !== undefined) {
    if (object === null || object === undefined) {
      throw new Error(util.format('\'%s\' cannot be null or undefined. \'%s\' is the ' + 
        'polmorphicDiscriminator and is a required property.', objectName, 
        mapper.type.polymorphicDiscriminator[polymorphicPropertyName]));
    }
    if (object[mapper.type.polymorphicDiscriminator[polymorphicPropertyName]] === null || 
        object[mapper.type.polymorphicDiscriminator[polymorphicPropertyName]] === undefined) {
      throw new Error(util.format('No discriminator field \'%s\' was found in \'%s\'.', 
        mapper.type.polymorphicDiscriminator[polymorphicPropertyName], objectName));
    }
    var indexDiscriminator = null;
    if (object[mapper.type.polymorphicDiscriminator[polymorphicPropertyName]] === mapper.type.uberParent) {
      indexDiscriminator = object[mapper.type.polymorphicDiscriminator[polymorphicPropertyName]];
    } else {
      indexDiscriminator = mapper.type.uberParent + '.' + object[mapper.type.polymorphicDiscriminator[polymorphicPropertyName]];
    }
    if (!this.models.discriminators[indexDiscriminator]) {
      throw new Error(util.format('\'%s\': \'%s\' in \'%s\' is not a valid ' + 
        'discriminator as a corresponding model class for the disciminator \'%s\' ' + 
        'was not found in this.models.discriminators object.', 
        mapper.type.polymorphicDiscriminator[polymorphicPropertyName], object[mapper.type.polymorphicDiscriminator[polymorphicPropertyName]], objectName, indexDiscriminator));
    }
    mapper = new this.models.discriminators[indexDiscriminator]().mapper();
  }
  return mapper;
}

//processes old version of the polymorphicDiscriminator in the mapper.
function _getPolymorphicMapperStringVersion(mapper, object, objectName) {
  /*jshint validthis: true */
  //check for polymorphic discriminator
  if (mapper.type.polymorphicDiscriminator !== null && mapper.type.polymorphicDiscriminator !== undefined) {
    if (object === null || object === undefined) {
      throw new Error(util.format('\'%s\' cannot be null or undefined. \'%s\' is the ' + 
        'polmorphicDiscriminator and is a required property.', objectName, 
        mapper.type.polymorphicDiscriminator));
    }
    if (object[mapper.type.polymorphicDiscriminator] === null || object[mapper.type.polymorphicDiscriminator] === undefined) {
      throw new Error(util.format('No discriminator field \'%s\' was found in \'%s\'.', 
        mapper.type.polymorphicDiscriminator, objectName));
    }
    var indexDiscriminator = null;
    if (object[mapper.type.polymorphicDiscriminator] === mapper.type.uberParent) {
      indexDiscriminator = object[mapper.type.polymorphicDiscriminator];
    } else {
      indexDiscriminator = mapper.type.uberParent + '.' + object[mapper.type.polymorphicDiscriminator];
    }
    if (!this.models.discriminators[indexDiscriminator]) {
      throw new Error(util.format('\'%s\': \'%s\'  in \'%s\' is not a valid ' + 
        'discriminator as a corresponding model class for the disciminator \'%s\' ' + 
        'was not found in this.models.discriminators object.', 
        mapper.type.polymorphicDiscriminator, object[mapper.type.polymorphicDiscriminator], objectName, indexDiscriminator));
    }
    mapper = new this.models.discriminators[indexDiscriminator]().mapper();
  }
  return mapper;
}

function bufferToBase64Url(buffer) {
  if (!buffer) {
    return null;
  }
  if (!Buffer.isBuffer(buffer)) {
    throw new Error('Please provide an input of type Buffer for converting to Base64Url.');
  }
  // Buffer to Base64.
  var str = buffer.toString('base64');
  // Base64 to Base64Url.
  return trimEnd(str, '=').replace(/\+/g, '-').replace(/\//g, '_');
}

function trimEnd(str, ch) {
  var len = str.length;
  while ((len - 1) >= 0 && str[len - 1] === ch) {
    --len;
  }
  return str.substr(0, len);
}

function base64UrlToBuffer(str) {
  if (!str) {
    return null;
  }
  if (str && typeof str.valueOf() !== 'string') {
    throw new Error('Please provide an input of type string for converting to Buffer');
  }
  // Base64Url to Base64.
  str = str.replace(/\-/g, '+').replace(/\_/g, '/');
  // Base64 to Buffer.
  return new Buffer(str, 'base64');
}

function dateToUnixTime(d) {
  if (!d) {
    return null;
  }
  if (typeof d.valueOf() === 'string') {
    d = new Date(d);
  }
  return parseInt(d.getTime() / 1000);
}

function unixTimeToDate(n) {
  if (!n) {
    return null;
  }
  return new Date(n*1000);
}

exports = module.exports;