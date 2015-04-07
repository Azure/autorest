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

// Module dependencies.
var _ = require('underscore');

var atomHandler = require('./atomhandler');

var azureutil = require('./util');
var Constants = require('./constants');
var edmType = require('./edmtype');

function OdataHandler(nsMeta, nsData) {
  this.nsMeta = nsMeta;
  if (this.nsMeta === undefined) {
    this.nsMeta = OdataHandler.NSMETA;
  }

  this.nsData = nsData;
  if (this.nsData === undefined) {
    this.nsData = OdataHandler.NSDATA;
  }
}

OdataHandler.NSMETA = 'm';
OdataHandler.NSDATA = 'd';

OdataHandler.prototype.parse = function (response) {
  var self = this;

  var result = null;

  function parseEntity(atomEntity) {
    var entity = {};

    if (atomEntity[Constants.ATOM_METADATA_MARKER]) {
      entity[Constants.ATOM_METADATA_MARKER] = {};

      for (var metaProperty in atomEntity[Constants.ATOM_METADATA_MARKER]) {
        if (atomEntity[Constants.ATOM_METADATA_MARKER].hasOwnProperty(metaProperty)) {
          var metaPropertyName = metaProperty;
          if (azureutil.stringStartsWith(metaPropertyName, self.nsMeta + ':')) {
            metaPropertyName = metaProperty.substr(self.nsMeta.length + 1, metaProperty.length - (self.nsMeta.length + 1));
          }

          entity[Constants.ATOM_METADATA_MARKER][metaPropertyName] = atomEntity[Constants.ATOM_METADATA_MARKER][metaProperty];

          if (metaPropertyName === 'link' && entity[Constants.ATOM_METADATA_MARKER][metaPropertyName][Constants.XML_METADATA_MARKER]) {
            entity[Constants.ATOM_METADATA_MARKER][metaPropertyName] = entity[Constants.ATOM_METADATA_MARKER][metaPropertyName][Constants.XML_METADATA_MARKER]['href'];
          }
        }
      }
    }

    for (var property in atomEntity) {
      if (atomEntity.hasOwnProperty(property)) {
        var propertyName = property;
        if (azureutil.stringStartsWith(propertyName, self.nsData + ':')) {
          propertyName = property.substr(self.nsData.length + 1, property.length - (self.nsData.length + 1));
        }

        if (property !== Constants.ATOM_METADATA_MARKER) {
          if (azureutil.objectIsEmpty(atomEntity[property])) {
            // Empty properties are represented as an empty string.
            entity[propertyName] = '';
          } else if (atomEntity[property][Constants.XML_METADATA_MARKER] !== undefined &&
              atomEntity[property][Constants.XML_METADATA_MARKER][self._xmlQualifyXmlTagName('null', self.nsMeta)] &&
              atomEntity[property][Constants.XML_METADATA_MARKER][self._xmlQualifyXmlTagName('null', self.nsMeta)] === 'true') {
            entity[propertyName] = null;
          } else if (atomEntity[property][Constants.XML_VALUE_MARKER] !== undefined) {
            // Has an entry for value
            if (atomEntity[property][Constants.XML_METADATA_MARKER] &&
              atomEntity[property][Constants.XML_METADATA_MARKER][self._xmlQualifyXmlTagName('type', self.nsMeta)]) {
              // Has metadata for type
              self._setProperty(
                entity,
                propertyName,
                atomEntity[property][Constants.XML_VALUE_MARKER],
                atomEntity[property][Constants.XML_METADATA_MARKER][self._xmlQualifyXmlTagName('type', self.nsMeta)]);
            } else {
              // The situation where a value marker exists and no type / null metadata marker exists shouldn't happen, but, just in case ...
              entity[propertyName] = atomEntity[property][Constants.XML_VALUE_MARKER];
            }
          } else {
            entity[propertyName] = atomEntity[property];
          }
        }
      }
    }

    return entity;
  }

  var parsedResponse = atomHandler.parse(response);
  if (_.isArray(parsedResponse)) {
    result = [];

    parsedResponse.forEach(function (content) {
      result.push(parseEntity(content));
    });
  } else {
    result = parseEntity(parsedResponse);
  }

  return result;
};

/**
* Qualifies an XML tag name with the specified prefix.
* This operates at the lexical level - there is no awareness of in-scope prefixes.
*
* @param {string} name      Element name.
* @param {string} prefix    Prefix to use, possibly null.
* @return {string} The qualified tag name.
*/
OdataHandler.prototype._xmlQualifyXmlTagName = function (name, prefix) {
  if (prefix) {
    return prefix + ':' + name;
  }

  return name;
};

/**
* Sets an entity property based on its target name, value and type.
*
* @param {object} entity       The entity descriptor where to set the property.
* @param {string} propertyName The target property name.
* @param {object} value        The property value.
* @param {string} type         The name of the property's type.
*/
OdataHandler.prototype._setProperty = function (entity, propertyName, value, type) {
  entity[propertyName] = edmType.unserializeValue(type, value);
};

/*
* Serializes an entity to an Odata (Atom based) payload.
*
* The following formats are accepted:
* - { stringValue: { '$': { type: 'Edm.String' }, '_': 'my string' }, myInt: { '$': { type: 'Edm.Int32' }, '_': 3 } }
* - { stringValue: 'my string', myInt: 3 }
*/
OdataHandler.prototype.serialize = function (entity, skipType) {
  var self = this;
  var properties = {};

  Object.keys(entity).forEach(function (name) {
    if (name !== '_') {
      var propertyName = self._xmlQualifyXmlTagName(name, self.nsData);
      properties[propertyName] = { };
      properties[propertyName][Constants.XML_METADATA_MARKER] = {};

      var propertyType = null;
      var propertyValue = null;

      if (entity[name] &&
          entity[name][Constants.XML_METADATA_MARKER] !== undefined &&
          entity[name][Constants.XML_METADATA_MARKER].type !== undefined) {

        propertyType = entity[name][Constants.XML_METADATA_MARKER].type;
        if (entity[name][Constants.XML_VALUE_MARKER] !== undefined) {
          propertyValue = edmType.serializeValue(propertyType, entity[name][Constants.XML_VALUE_MARKER]);
        }
      }
      else {
        if (entity[name] !== undefined && entity[name] !== null) {
          propertyType = edmType.propertyType(entity[name]);
        }

        propertyValue = edmType.serializeValue(propertyType, entity[name]);
      }

      properties[OdataHandler.NSDATA + ':' + name][Constants.XML_VALUE_MARKER] = propertyValue;

      if (!skipType && propertyType !== null) {
        properties[OdataHandler.NSDATA + ':' + name][Constants.XML_METADATA_MARKER][self._xmlQualifyXmlTagName('type',  self.nsMeta)] = propertyType;
      }

      if (azureutil.stringIsEmpty(propertyValue)) {
        properties[OdataHandler.NSDATA + ':' + name][Constants.XML_METADATA_MARKER][self._xmlQualifyXmlTagName('null', self.nsMeta)] = true;
      }
    }
  });

  var content = {};
  content[self._xmlQualifyXmlTagName('properties', self.nsMeta)] = properties;

  return atomHandler.serializeEntry(content, [
    {
      key: OdataHandler.NSDATA,
      url: 'http://schemas.microsoft.com/ado/2007/08/dataservices'
    },
    {
      key: OdataHandler.NSMETA,
      url: 'http://schemas.microsoft.com/ado/2007/08/dataservices/metadata'
    }
  ]);
};

module.exports = OdataHandler;