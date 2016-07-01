# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure

  describe PollingState do
    it 'should initialize status from flattened response body' do
      response_body = double('response_body', :provisioning_state => 'InProgress')
      response = double('response',
                        :request => nil,
                        :response => nil,
                        :body => response_body)

      polling_state = PollingState.new response, 0

      expect(polling_state.status).to eq('InProgress')
    end

    it 'should initialize status from non-flattened response body' do
      provisioning_state = double('provisioning_state', :provisioning_state => 'Succeeded')
      response_body = double('response_body', :properties => provisioning_state)
      response = double('response',
                        :request => nil,
                        :response => nil,
                        :body => response_body)

      polling_state = PollingState.new response, 0

      expect(polling_state.status).to eq('Succeeded')
    end

    it 'should initialize status from response status' do
      response = double('response', :status => 200, :headers => {})

      azure_response = double('azure_response',
                        :request => nil,
                        :response => response,
                        :body => nil)

      polling_state = PollingState.new azure_response, 0

      expect(polling_state.status).to eq(AsyncOperationStatus::SUCCESS_STATUS)
    end

    it 'should grab azure headers from response' do
      response = double('response', :headers =>
                                      { 'Azure-AsyncOperation' => 'async_operation_header',
                                        'Location' => 'location_header'},
                                    :status => 204)

      azure_response = double('azure_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new azure_response, 0

      expect(polling_state.azure_async_operation_header_link).to eq('async_operation_header')
      expect(polling_state.location_header_link).to eq('location_header')
    end

    it 'should grab timeout from constructor' do
      response = double('response', :headers =>
                                      { 'RetryAfter' => 5 },
                        :status => 204)

      azure_response = double('azure_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new azure_response, 3

      expect(polling_state.get_delay).to eq(3)
    end

    it 'should grab timeout from response' do
      response = double('response', :headers =>
                                      { 'Retry-After' => 5 },
                        :status => 204)

      azure_response = double('azure_response',
                              :request => nil,
                              :response => response,
                              :body => nil)

      polling_state = PollingState.new azure_response, nil

      expect(polling_state.get_delay).to eq(5)
    end
  end

end