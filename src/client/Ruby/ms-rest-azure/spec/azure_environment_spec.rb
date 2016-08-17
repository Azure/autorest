# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure
  describe 'Azure Environment' do
    before (:each) do
      @valid_min_options = {
          :name => 'DogFood',
          :portal_url => 'http://go.microsoft.com/fwlink/?LinkId=254433',
          :management_endpoint_url => 'https://management.core.windows.net',
          :resource_manager_endpoint_url => 'https://management.azure.com/',
          :active_directory_endpoint_url => 'https://login.microsoftonline.com/',
          :active_directory_resource_id => 'https://management.core.windows.net/'
      }

      @insufficient_min_options = {
          :name => 'DogFood',
          :portal_url => 'http://go.microsoft.com/fwlink/?LinkId=254433',
          :management_endpoint_url => 'https://management.core.windows.net',
          :resource_manager_endpoint_url => 'https://management.azure.com/',
          :active_directory_resource_id => 'https://management.core.windows.net/'
      }

      @invalid_min_options = {
          :name => 'DogFood',
          :portal_url => 'http://go.microsoft.com/fwlink/?LinkId=254433',
          :management_endpoint_url => 'https://management.core.windows.net',
          :resource_manager_endpoint_url => 1,
          :active_directory_endpoint_url => 'https://login.microsoftonline.com/',
          :active_directory_resource_id => 'https://management.core.windows.net/'
      }
    end


    it 'should initialize with required properties' do
      azure_environment = AzureEnvironments::AzureEnvironment.new(@valid_min_options)

      expect(azure_environment).to be_a(AzureEnvironments::AzureEnvironment)
      expect(azure_environment.name).to eq('DogFood')
      expect(azure_environment.portal_url).to eq('http://go.microsoft.com/fwlink/?LinkId=254433')
      expect(azure_environment.management_endpoint_url).to eq('https://management.core.windows.net')
      expect(azure_environment.resource_manager_endpoint_url).to eq('https://management.azure.com/')
      expect(azure_environment.active_directory_endpoint_url).to eq('https://login.microsoftonline.com/')
      expect(azure_environment.active_directory_resource_id).to eq('https://management.core.windows.net/')
      expect(azure_environment.validate_authority).to be_truthy
    end

    it 'should raise with insufficient or wrong properties' do
      expect { AzureEnvironments::AzureEnvironment.new(@insufficient_min_options) }.to raise_error(ArgumentError)

      expect { AzureEnvironments::AzureEnvironment.new(@invalid_min_options) }.to raise_error(ArgumentError)
    end

    it 'should contain pre-defined environments' do
      expect(MsRestAzure::AzureEnvironments::Azure).to be_a(AzureEnvironments::AzureEnvironment)
      expect(MsRestAzure::AzureEnvironments::AzureChina).to be_a(AzureEnvironments::AzureEnvironment)
      expect(MsRestAzure::AzureEnvironments::AzureUSGovernment).to be_a(AzureEnvironments::AzureEnvironment)
      expect(MsRestAzure::AzureEnvironments::AzureGermanCloud).to be_a(AzureEnvironments::AzureEnvironment)
    end
  end
end
