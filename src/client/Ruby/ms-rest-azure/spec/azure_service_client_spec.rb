# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'concurrent'
require 'ms_rest_azure'

module MsRestAzure

  describe AzureServiceClient do
    before(:all) do
      @methods = ['put', 'post', 'delete', 'patch']
    end

    it 'should throw error in case provided azure response is nil' do
      azure_service_client = AzureServiceClient.new nil
      expect { azure_service_client.get_long_running_operation_result(nil, nil) }.to raise_error(MsRest::ValidationError)
    end

    it 'should throw error if unexpected polling state is passed' do
      azure_service_client = AzureServiceClient.new nil

      response = double('response', :status => 404)
      request = double('request', headers: {}, base_uri: '', method: @methods[0])

      azure_response = double('azure_response',
                              :request => request,
                              :response => response,
                              :body => nil)

      expect { azure_service_client.get_long_running_operation_result(azure_response, nil) }.to raise_error(AzureOperationError)
    end

    it 'should use async operation header when async_operation_header present' do
      azure_service_client = AzureServiceClient.new nil
      azure_service_client.long_running_operation_retry_timeout = 0

      allow_any_instance_of(MsRestAzure::PollingState).to receive(:create_connection).and_return(nil)
      allow(azure_service_client).to receive(:update_state_from_azure_async_operation_header) do |request, polling_state|
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = 'resource'
      end

      response = double('response',
                        :headers =>
                            { 'Azure-AsyncOperation' => 'async_operation_header',
                              'Location' => 'location_header'},
                        :status => 202)
      expect(azure_service_client).to receive(:update_state_from_azure_async_operation_header)

      @methods.each do |method|
        request = double('request', headers: {}, base_uri: '', method: method)
        azure_response = double('azure_response',
                                :request => request,
                                :response => response,
                                :body => nil)
        azure_service_client.get_long_running_operation_result(azure_response, nil)
      end
    end

    it 'should use location operation header when location_header present' do
      azure_service_client = AzureServiceClient.new nil
      azure_service_client.long_running_operation_retry_timeout = 0

      allow_any_instance_of(MsRestAzure::PollingState).to receive(:create_connection).and_return(nil)
      allow(azure_service_client).to receive(:update_state_from_location_header) do |request, polling_state|
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = 'resource'
      end

      response = double('response', :headers => { 'Location' => 'location_header'}, :status => 202)
      expect(azure_service_client).to receive(:update_state_from_location_header)

      @methods.each do |method|
        request = double('request', headers: {}, base_uri: '', method: method)
        azure_response = double('azure_response',
                                :request => request,
                                :response => response,
                                :body => nil)
        azure_service_client.get_long_running_operation_result(azure_response, nil)
      end
    end

    it 'should throw error in case LRO ends up with failed status' do
      azure_service_client = AzureServiceClient.new nil
      azure_service_client.long_running_operation_retry_timeout = 0

      allow_any_instance_of(MsRestAzure::PollingState).to receive(:create_connection).and_return(nil)
      allow(azure_service_client).to receive(:update_state_from_azure_async_operation_header) do |request, polling_state|
        polling_state.status = AsyncOperationStatus::FAILED_STATUS
      end

      response = double('response', :headers =>
                                      { 'Azure-AsyncOperation' => 'async_operation_header' },
                                    :status => 202)

      @methods.each do |method|
        request = double('request', headers: {}, base_uri: '', method: method)
        azure_response = double('azure_response',
                                :request => request,
                                :response => response,
                                :body => nil)
        expect { azure_service_client.get_long_running_operation_result(azure_response, nil) }.to raise_error(AzureOperationError)
      end
    end
  end
end
