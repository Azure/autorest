# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'concurrent'
require 'ms_rest_azure'

module MsRestAzure

  describe AzureServiceClient do
    it 'should throw error in case provided azure response is nil' do
      azure_service_client = AzureServiceClient.new nil
      expect { azure_service_client.get_put_operation_result(nil, nil, nil) }.to raise_error(MsRest::ValidationError)
    end

    it 'should throw error if unexpected polling state is passed' do
      azure_service_client = AzureServiceClient.new nil

      response = double('response', :status => 404)

      azure_response = double('azure_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      expect { azure_service_client.get_put_operation_result(azure_response, nil, nil) }.to raise_error(AzureOperationError)
    end

    it 'should use async operation header for getting PUT result' do
      azure_service_client = AzureServiceClient.new nil
      azure_service_client.long_running_operation_retry_timeout = 0

      allow(azure_service_client).to receive(:update_state_from_azure_async_operation_header) do |polling_state|
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = 'resource'
      end

      response = double('response', :headers =>
                                      { 'Azure-AsyncOperation' => 'async_operation_header',
                                        'Location' => 'location_header'},
                        :status => 202)

      request = double('request', :url_prefix => 'http://localhost')

      azure_response = double('azure_response',
                              :request => request,
                              :response => response,
                              :body => nil)

      expect(azure_service_client).to receive(:update_state_from_azure_async_operation_header)

      azure_service_client.get_put_operation_result(azure_response, nil, nil)
    end

    it 'should use location operation header for getting PUT result' do
      azure_service_client = AzureServiceClient.new nil
      azure_service_client.long_running_operation_retry_timeout = 0

      allow(azure_service_client).to receive(:update_state_from_location_header_on_put) do |polling_state|
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = 'resource'
      end

      response = double('response', :headers =>
                                      { 'Location' => 'location_header'},
                                    :status => 202)

      request = double('request', :url_prefix => 'http://localhost')

      azure_response = double('azure_response',
                              :request => request,
                              :response => response,
                              :body => nil)

      expect(azure_service_client).to receive(:update_state_from_location_header_on_put)

      azure_service_client.get_put_operation_result(azure_response, nil, nil)
    end

    it 'should throw error in case LRO ends up with failed status' do
      azure_service_client = AzureServiceClient.new nil
      azure_service_client.long_running_operation_retry_timeout = 0

      allow(azure_service_client).to receive(:update_state_from_azure_async_operation_header) do |polling_state|
        polling_state.status = AsyncOperationStatus::FAILED_STATUS
      end

      response = double('response', :headers =>
                                      { 'Azure-AsyncOperation' => 'async_operation_header' },
                                    :status => 202)

      request = double('request', :url_prefix => 'http://localhost')

      azure_response = double('azure_response',
                              :request => request,
                              :response => response,
                              :body => nil)

      expect { azure_service_client.get_put_operation_result(azure_response, nil, nil) }.to raise_error(AzureOperationError)
    end
  end

end