# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure
  describe AzureOperationError do
    let(:http_response) { double('http_response', body: nil, headers: nil, status: 500) }
    let(:http_request) { double('http_request') }
    let(:error_message) { 'resource group name is invalid' }
    let(:error_code) { 'InvalidResourceGroup' }
    let(:body) { { 'error' => { 'code' => error_code, 'message' => error_message } } }

    it 'should create error with message' do
      error = AzureOperationError.new 'error_message'
      expect(error.message).to match('error_message')
    end

    it 'should create error with request and response' do
      error = AzureOperationError.new(http_request, http_response)
      expect(error.request).to eq(http_request)
      expect(error.response).to eq(http_response)
      expect(error.body).to eq(nil)
      # message must not contain message from body but must contains class name
      expect(error.message).to match('MsRestAzure::AzureOperationError') # Default one
    end

    it 'should create error with request, response and body' do
      error = AzureOperationError.new(http_request, http_response, body)
      expect(error.request).to eq(http_request)
      expect(error.response).to eq(http_response)
      expect(error.body).to eq(body)
      # message must contain message from body
      expect(error.message).to match(error_message)
      # message must have error_message &  error_code property
      expect(error.error_message).to match(error_message)
      expect(error.error_code).to match(error_code)
    end

    it 'should create error with request, response, body and message' do
      error = AzureOperationError.new(http_request, http_response, body, 'error_message')
      expect(error.request).to eq(http_request)
      expect(error.response).to eq(http_response)
      expect(error.body).to eq(body)
      # message must contain message from body
      expect(error.message).to match(error_message)
      # message must have error_message &  error_code property
      expect(error.error_message).to match(error_message)
      expect(error.error_code).to match(error_code)
    end
  end
end
