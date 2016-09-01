# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure
  describe 'Active Directory Service Settings' do
    it 'should initialize with Azure Cloud properties' do
      aad_settings = ActiveDirectoryServiceSettings.get_azure_settings

      expect(aad_settings).to be_a(ActiveDirectoryServiceSettings)
      expect(aad_settings.authentication_endpoint).to eq(MsRestAzure::AzureEnvironments::Azure.active_directory_endpoint_url)
      expect(aad_settings.token_audience).to eq(MsRestAzure::AzureEnvironments::Azure.active_directory_resource_id)
    end

    it 'should initialize with Azure China Cloud properties' do
      aad_settings = ActiveDirectoryServiceSettings.get_azure_china_settings

      expect(aad_settings).to be_a(ActiveDirectoryServiceSettings)
      expect(aad_settings.authentication_endpoint).to eq(MsRestAzure::AzureEnvironments::AzureChina.active_directory_endpoint_url)
      expect(aad_settings.token_audience).to eq(MsRestAzure::AzureEnvironments::AzureChina.active_directory_resource_id)
    end

    it 'should initialize with Azure US Government Cloud properties' do
      aad_settings = ActiveDirectoryServiceSettings.get_azure_us_government_settings

      expect(aad_settings).to be_a(ActiveDirectoryServiceSettings)
      expect(aad_settings.authentication_endpoint).to eq(MsRestAzure::AzureEnvironments::AzureUSGovernment.active_directory_endpoint_url)
      expect(aad_settings.token_audience).to eq(MsRestAzure::AzureEnvironments::AzureUSGovernment.active_directory_resource_id)
    end

    it 'should initialize with Azure German Cloud properties' do
      aad_settings = ActiveDirectoryServiceSettings.get_azure_german_settings

      expect(aad_settings).to be_a(ActiveDirectoryServiceSettings)
      expect(aad_settings.authentication_endpoint).to eq(MsRestAzure::AzureEnvironments::AzureGermanCloud.active_directory_endpoint_url)
      expect(aad_settings.token_audience).to eq(MsRestAzure::AzureEnvironments::AzureGermanCloud.active_directory_resource_id)
    end
  end
end
