/*
 */

'use strict';

var models = require('./index');

var util = require('util');

/**
 * @class
 * Initializes a new instance of the StorageAccount class.
 * @constructor
 * The storage account.
 *
 * @member {object} [properties]
 * 
 * @member {string} [properties.provisioningState] Gets the status of the
 * storage account at the time the operation was called. Possible values
 * include: 'Creating', 'ResolvingDNS', 'Succeeded'
 * 
 * @member {string} [properties.accountType] Gets the type of the storage
 * account. Possible values include: 'Standard_LRS', 'Standard_ZRS',
 * 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
 * 
 * @member {object} [properties.primaryEndpoints] Gets the URLs that are used
 * to perform a retrieval of a public blob, queue or table object.Note that
 * StandardZRS and PremiumLRS accounts only return the blob endpoint.
 * 
 * @member {string} [properties.primaryEndpoints.blob] Gets the blob endpoint.
 * 
 * @member {string} [properties.primaryEndpoints.queue] Gets the queue
 * endpoint.
 * 
 * @member {string} [properties.primaryEndpoints.table] Gets the table
 * endpoint.
 * 
 * @member {string} [properties.primaryEndpoints.file] Gets the file endpoint.
 * 
 * @member {string} [properties.primaryLocation] Gets the location of the
 * primary for the storage account.
 * 
 * @member {string} [properties.statusOfPrimary] Gets the status indicating
 * whether the primary location of the storage account is available or
 * unavailable. Possible values include: 'Available', 'Unavailable'
 * 
 * @member {date} [properties.lastGeoFailoverTime] Gets the timestamp of the
 * most recent instance of a failover to the secondary location. Only the
 * most recent timestamp is retained. This element is not returned if there
 * has never been a failover instance. Only available if the accountType is
 * StandardGRS or StandardRAGRS.
 * 
 * @member {string} [properties.secondaryLocation] Gets the location of the
 * geo replicated secondary for the storage account. Only available if the
 * accountType is StandardGRS or StandardRAGRS.
 * 
 * @member {string} [properties.statusOfSecondary] Gets the status indicating
 * whether the secondary location of the storage account is available or
 * unavailable. Only available if the accountType is StandardGRS or
 * StandardRAGRS. Possible values include: 'Available', 'Unavailable'
 * 
 * @member {date} [properties.creationTime] Gets the creation date and time of
 * the storage account in UTC.
 * 
 * @member {object} [properties.customDomain] Gets the user assigned custom
 * domain assigned to this storage account.
 * 
 * @member {string} [properties.customDomain.name] Gets or sets the custom
 * domain name. Name is the CNAME source.
 * 
 * @member {boolean} [properties.customDomain.useSubDomain] Indicates whether
 * indirect CName validation is enabled. Default value is false. This should
 * only be set on updates
 * 
 * @member {object} [properties.secondaryEndpoints] Gets the URLs that are
 * used to perform a retrieval of a public blob, queue or table object from
 * the secondary location of the storage account. Only available if the
 * accountType is StandardRAGRS.
 * 
 * @member {string} [properties.secondaryEndpoints.blob] Gets the blob
 * endpoint.
 * 
 * @member {string} [properties.secondaryEndpoints.queue] Gets the queue
 * endpoint.
 * 
 * @member {string} [properties.secondaryEndpoints.table] Gets the table
 * endpoint.
 * 
 * @member {string} [properties.secondaryEndpoints.file] Gets the file
 * endpoint.
 * 
 */
function StorageAccount() {
  StorageAccount['super_'].call(this);
}

util.inherits(StorageAccount, models['Resource']);

/**
 * Defines the metadata of StorageAccount
 *
 * @returns {object} metadata of StorageAccount
 *
 */
StorageAccount.prototype.mapper = function () {
  return {
    required: false,
    serializedName: 'StorageAccount',
    type: {
      name: 'Composite',
      className: 'StorageAccount',
      modelProperties: {
        id: {
          required: false,
          readOnly: true,
          serializedName: 'id',
          type: {
            name: 'String'
          }
        },
        name: {
          required: false,
          readOnly: true,
          serializedName: 'name',
          type: {
            name: 'String'
          }
        },
        type: {
          required: false,
          readOnly: true,
          serializedName: 'type',
          type: {
            name: 'String'
          }
        },
        location: {
          required: false,
          serializedName: 'location',
          type: {
            name: 'String'
          }
        },
        tags: {
          required: false,
          serializedName: 'tags',
          type: {
            name: 'Dictionary',
            value: {
                required: false,
                serializedName: 'StringElementType',
                type: {
                  name: 'String'
                }
            }
          }
        },
        properties: {
          required: false,
          serializedName: 'properties',
          type: {
            name: 'Composite',
            className: 'StorageAccountProperties'
          }
        }
      }
    }
  };
};

module.exports = StorageAccount;
