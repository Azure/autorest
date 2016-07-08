// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

var should = require('should');
var msRestAzure = require('../lib/msRestAzure');

describe('AzureEnvironment', function() {
  it('can be properly required', function(done) {
    var tempEnv = msRestAzure.AzureEnvironment;
    tempEnv.validateAuthority.should.equal(true);
    done();
  });

  it('should show the details of Azure Production environment correctly', function(done) {
    var tempEnv = msRestAzure.AzureEnvironment.Azure;
    tempEnv.name.should.equal('Azure');
    tempEnv.activeDirectoryEndpointUrl.should.equal('https://login.microsoftonline.com/');
    tempEnv.activeDirectoryResourceId.should.equal('https://management.core.windows.net/');
    tempEnv.managementEndpointUrl.should.equal('https://management.core.windows.net');
    tempEnv.resourceManagerEndpointUrl.should.equal('https://management.azure.com/');
    tempEnv.portalUrl.should.equal('http://go.microsoft.com/fwlink/?LinkId=254433');
    tempEnv.validateAuthority.should.equal(true);
    done();
  });

  it('should show the details of Azure China environment correctly', function(done) {
    var tempEnv = msRestAzure.AzureEnvironment.AzureChina;
    tempEnv.name.should.equal('AzureChina');
    tempEnv.activeDirectoryEndpointUrl.should.equal('https://login.chinacloudapi.cn/');
    tempEnv.activeDirectoryResourceId.should.equal('https://management.core.chinacloudapi.cn/');
    tempEnv.managementEndpointUrl.should.equal('https://management.core.chinacloudapi.cn');
    tempEnv.resourceManagerEndpointUrl.should.equal('https://management.chinacloudapi.cn');
    tempEnv.portalUrl.should.equal('http://go.microsoft.com/fwlink/?LinkId=301902');
    tempEnv.validateAuthority.should.equal(true);
    done();
  });

  it('should show the details of Azure USGovernment environment correctly', function(done) {
    var tempEnv = msRestAzure.AzureEnvironment.AzureUSGovernment;
    tempEnv.name.should.equal('AzureUSGovernment');
    tempEnv.activeDirectoryEndpointUrl.should.equal('https://login.microsoftonline.com/');
    tempEnv.activeDirectoryResourceId.should.equal('https://management.core.usgovcloudapi.net/');
    tempEnv.managementEndpointUrl.should.equal('https://management.core.usgovcloudapi.net');
    tempEnv.resourceManagerEndpointUrl.should.equal('https://management.usgovcloudapi.net');
    tempEnv.portalUrl.should.equal('https://manage.windowsazure.us');
    tempEnv.validateAuthority.should.equal(true);
    done();
  });

  it('should show the details of Azure GermanCloud environment correctly', function(done) {
    var tempEnv = msRestAzure.AzureEnvironment.AzureGermanCloud;
    tempEnv.name.should.equal('AzureGermanCloud');
    tempEnv.activeDirectoryEndpointUrl.should.equal('https://login.microsoftonline.de/');
    tempEnv.activeDirectoryResourceId.should.equal('https://management.core.cloudapi.de/');
    tempEnv.managementEndpointUrl.should.equal('https://management.core.cloudapi.de');
    tempEnv.resourceManagerEndpointUrl.should.equal('https://management.microsoftazure.de');
    tempEnv.portalUrl.should.equal('http://portal.microsoftazure.de/');
    tempEnv.validateAuthority.should.equal(true);
    done();
  });

  it('should be able to add a new environment', function(done) {
    var df = {
      name: 'Dogfood',
      portalUrl: 'http://go.microsoft.com/fwlink/?LinkId=254433',
      managementEndpointUrl: 'https://management.core.windows.net',
      resourceManagerEndpointUrl: 'https://management.azure.com/',
      activeDirectoryEndpointUrl: 'https://login.microsoftonline.com/',
      activeDirectoryResourceId: 'https://management.core.windows.net/'
    };
    var tempEnv = msRestAzure.AzureEnvironment;
    var dfood = tempEnv.add(df);
    dfood.name.should.equal('Dogfood');
    dfood.activeDirectoryEndpointUrl.should.equal('https://login.microsoftonline.com/');
    dfood.activeDirectoryResourceId.should.equal('https://management.core.windows.net/');
    dfood.managementEndpointUrl.should.equal('https://management.core.windows.net');
    dfood.resourceManagerEndpointUrl.should.equal('https://management.azure.com/');
    dfood.portalUrl.should.equal('http://go.microsoft.com/fwlink/?LinkId=254433');
    dfood.validateAuthority.should.equal(true);

    //Verify that the environment properly got added to the prototype
    tempEnv.Dogfood.name.should.equal('Dogfood');
    tempEnv.Dogfood.activeDirectoryEndpointUrl.should.equal('https://login.microsoftonline.com/');
    tempEnv.Dogfood.activeDirectoryResourceId.should.equal('https://management.core.windows.net/');
    tempEnv.Dogfood.managementEndpointUrl.should.equal('https://management.core.windows.net');
    tempEnv.Dogfood.resourceManagerEndpointUrl.should.equal('https://management.azure.com/');
    tempEnv.Dogfood.portalUrl.should.equal('http://go.microsoft.com/fwlink/?LinkId=254433');
    tempEnv.Dogfood.validateAuthority.should.equal(true);
    done();
  });
});