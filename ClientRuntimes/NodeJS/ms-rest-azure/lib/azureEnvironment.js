// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information. 

'use strict';
var util = require('util');
/**
 * @class
 * Initializes a new instance of the AzureEnvironment class.
 * @constructor
 * @param {string} parameters.name - The Environment name
 * @param {string} parameters.portalUrl - the management portal URL
 * @param {string} parameters.managementEndpointUrl - the management service endpoint
 * @param {string} parameters.resourceManagerEndpointUrl - the resource management endpoint
 * @param {string} parameters.activeDirectoryEndpointUrl - the Active Directory login endpoint
 * @param {string} parameters.activeDirectoryResourceId - The resource ID to obtain AD tokens for
 * @param {string} [parameters.publishingProfileUrl] - the publish settings file URL
 * @param {string} [parameters.sqlManagementEndpointUrl] - the sql server management endpoint for mobile commands
 * @param {string} [parameters.sqlServerHostnameSuffix] - the dns suffix for sql servers
 * @param {string} [parameters.galleryEndpointUrl] - the template gallery endpoint
 * @param {string} [parameters.activeDirectoryGraphResourceId] - the Active Directory resource ID
 * @param {string} [parameters.activeDirectoryGraphApiVersion] - the Active Directory api version
 * @param {string} [parameters.storageEndpointSuffix] - the endpoint suffix for storage accounts
 * @param {string} [parameters.keyVaultDnsSuffix] - the keyvault service dns suffix
 * @param {string} [parameters.azureDataLakeStoreFileSystemEndpointSuffix] - the data lake store filesystem service dns suffix
 * @param {string} [parameters.azureDataLakeAnalyticsCatalogAndJobEndpointSuffix] - the data lake analytics job and catalog service dns suffix
 * @param {bool} [parameters.validateAuthority] - Determines whether the authentication endpoint should 
 * be validated with Azure AD. Default value is true.
 */
function AzureEnvironment(parameters) {
  //Set defaults.
  this.validateAuthority = true;

  if (parameters) {
    //Validate required parameters
    var requiredParams = [ 'name', 'portalUrl', 'managementEndpointUrl', 'resourceManagerEndpointUrl', 
    'activeDirectoryEndpointUrl', 'activeDirectoryResourceId'];
    requiredParams.forEach(function (param) {
      if (!parameters[param] || typeof parameters[param].valueOf() !== 'string') {
        throw new Error(util.format('Please provide "%s" for the environment and it must be of type "string".', param));
      }
    });
    //Assign provided parameters
    for (var prop in parameters) {
      this[prop] = parameters[prop];
    }
  }
}
var supportedEnvironments = {
  Azure: {
    name: 'Azure',
    portalUrl: 'http://go.microsoft.com/fwlink/?LinkId=254433',
    publishingProfileUrl: 'http://go.microsoft.com/fwlink/?LinkId=254432',
    managementEndpointUrl: 'https://management.core.windows.net',
    resourceManagerEndpointUrl: 'https://management.azure.com/',
    sqlManagementEndpointUrl: 'https://management.core.windows.net:8443/',
    sqlServerHostnameSuffix: '.database.windows.net',
    galleryEndpointUrl: 'https://gallery.azure.com/',
    activeDirectoryEndpointUrl: 'https://login.microsoftonline.com/',
    activeDirectoryResourceId: 'https://management.core.windows.net/',
    activeDirectoryGraphResourceId: 'https://graph.windows.net/',
    activeDirectoryGraphApiVersion: '2013-04-05',
    storageEndpointSuffix: '.core.windows.net',
    keyVaultDnsSuffix: '.vault.azure.net',
    azureDataLakeStoreFileSystemEndpointSuffix: 'azuredatalakestore.net',
    azureDataLakeAnalyticsCatalogAndJobEndpointSuffix: 'azuredatalakeanalytics.net'
  },
  AzureChina: {
    name: 'AzureChina',
    portalUrl: 'http://go.microsoft.com/fwlink/?LinkId=301902',
    publishingProfileUrl: 'http://go.microsoft.com/fwlink/?LinkID=301774',
    managementEndpointUrl: 'https://management.core.chinacloudapi.cn',
    resourceManagerEndpointUrl: 'https://management.chinacloudapi.cn',
    sqlManagementEndpointUrl: 'https://management.core.chinacloudapi.cn:8443/',
    sqlServerHostnameSuffix: '.database.chinacloudapi.cn',
    galleryEndpointUrl: 'https://gallery.chinacloudapi.cn/',
    activeDirectoryEndpointUrl: 'https://login.chinacloudapi.cn/',
    activeDirectoryResourceId: 'https://management.core.chinacloudapi.cn/',
    activeDirectoryGraphResourceId: 'https://graph.chinacloudapi.cn/',
    activeDirectoryGraphApiVersion: '2013-04-05',
    storageEndpointSuffix: '.core.chinacloudapi.cn',
    keyVaultDnsSuffix: '.vault.azure.cn',
    // TODO: add dns suffixes for the china cloud for datalake store and datalake analytics once they are defined.
    azureDataLakeStoreFileSystemEndpointSuffix: 'N/A',
    azureDataLakeAnalyticsCatalogAndJobEndpointSuffix: 'N/A'
  },
  AzureUSGovernment: {
    name: 'AzureUSGovernment',
    portalUrl: 'https://manage.windowsazure.us',
    publishingProfileUrl: 'https://manage.windowsazure.us/publishsettings/index',
    managementEndpointUrl: 'https://management.core.usgovcloudapi.net',
    resourceManagerEndpointUrl: 'https://management.usgovcloudapi.net',
    sqlManagementEndpointUrl: 'https://management.core.usgovcloudapi.net:8443/',
    sqlServerHostnameSuffix: '.database.usgovcloudapi.net',
    galleryEndpointUrl: 'https://gallery.usgovcloudapi.net/',
    activeDirectoryEndpointUrl: 'https://login.microsoftonline.com/',
    activeDirectoryResourceId: 'https://management.core.usgovcloudapi.net/',
    activeDirectoryGraphResourceId: 'https://graph.windows.net/',
    activeDirectoryGraphApiVersion: '2013-04-05',
    storageEndpointSuffix: '.core.usgovcloudapi.net',
    keyVaultDnsSuffix: '.vault.usgovcloudapi.net',
    // TODO: add dns suffixes for the US government for datalake store and datalake analytics once they are defined.
    azureDataLakeStoreFileSystemEndpointSuffix: 'N/A',
    azureDataLakeAnalyticsCatalogAndJobEndpointSuffix: 'N/A'
  },
  AzureGermanCloud: {
    name: 'AzureGermanCloud',
    portalUrl: 'http://portal.microsoftazure.de/',
    publishingProfileUrl: 'https://manage.microsoftazure.de/publishsettings/index',
    managementEndpointUrl: 'https://management.core.cloudapi.de',
    resourceManagerEndpointUrl: 'https://management.microsoftazure.de',
    sqlManagementEndpointUrl: 'https://management.core.cloudapi.de:8443/',
    sqlServerHostnameSuffix: '.database.cloudapi.de',
    galleryEndpointUrl: 'https://gallery.cloudapi.de/',
    activeDirectoryEndpointUrl: 'https://login.microsoftonline.de/',
    activeDirectoryResourceId: 'https://management.core.cloudapi.de/',
    activeDirectoryGraphResourceId: 'https://graph.cloudapi.de/',
    activeDirectoryGraphApiVersion: '2013-04-05',
    storageEndpointSuffix: '.core.cloudapi.de',
    keyVaultDnsSuffix: '.vault.microsoftazure.de',
    // TODO: add dns suffixes for the US government for datalake store and datalake analytics once they are defined.
    azureDataLakeStoreFileSystemEndpointSuffix: 'N/A',
    azureDataLakeAnalyticsCatalogAndJobEndpointSuffix: 'N/A'
  }
};

/**
 * Adds a new instance of the AzureEnvironment to the prototype.
 * @param {string} parameters.name - The Environment name
 * @param {string} parameters.portalUrl - the management portal URL
 * @param {string} parameters.managementEndpointUrl - the management service endpoint
 * @param {string} parameters.resourceManagerEndpointUrl - the resource management endpoint
 * @param {string} parameters.activeDirectoryEndpointUrl - the Active Directory login endpoint
 * @param {string} parameters.activeDirectoryResourceId - The resource ID to obtain AD tokens for
 * @param {string} [parameters.publishingProfileUrl] - the publish settings file URL
 * @param {string} [parameters.sqlManagementEndpointUrl] - the sql server management endpoint for mobile commands
 * @param {string} [parameters.sqlServerHostnameSuffix] - the dns suffix for sql servers
 * @param {string} [parameters.galleryEndpointUrl] - the template gallery endpoint
 * @param {string} [parameters.activeDirectoryGraphResourceId] - the Active Directory resource ID
 * @param {string} [parameters.activeDirectoryGraphApiVersion] - the Active Directory api version
 * @param {string} [parameters.storageEndpointSuffix] - the endpoint suffix for storage accounts
 * @param {string} [parameters.keyVaultDnsSuffix] - the keyvault service dns suffix
 * @param {string} [parameters.azureDataLakeStoreFileSystemEndpointSuffix] - the data lake store filesystem service dns suffix
 * @param {string} [parameters.azureDataLakeAnalyticsCatalogAndJobEndpointSuffix] - the data lake analytics job and catalog service dns suffix
 * @param {bool} [parameters.validateAuthority] - Determines whether the authentication endpoint should 
 * be validated with Azure AD. Default value is true.
 * @return {AzureEnvironment} - Reference to the newly added Environment
 */
AzureEnvironment.prototype.add = function(parameters) {
  var _environment = new AzureEnvironment(parameters);
  AzureEnvironment.prototype[_environment.name] = _environment;
  return _environment;
};

//Adding the supported environments
for(var key in supportedEnvironments) {
  AzureEnvironment.prototype.add(supportedEnvironments[key]);
}

module.exports = new AzureEnvironment();