# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure

  describe AsyncOperationStatus do
    it 'should deserialize AsyncOperationStatus correctly' do
      response_json = {
          'status' => 'Succeeded',
          'error' => nil,
          'retryAfter' => 5
      }

      status = AsyncOperationStatus.deserialize_object response_json

      expect(status.status).to eq(AsyncOperationStatus::SUCCESS_STATUS)
      expect(status.error).to be_nil
      expect(status.retry_after).to eq(5)
    end

    it 'should deserialize AsyncOperationStatus with error data too' do
      response_json = {
          'status' => 'Failed',
          'error' => {
              'code' => 'the error code',
              'message' => 'the error message'
          },
          'retryAfter' => 10
      }

      status = AsyncOperationStatus.deserialize_object response_json

      expect(status.status).to eq(AsyncOperationStatus::FAILED_STATUS)
      expect(status.error.code).to eq('the error code')
      expect(status.error.message).to eq('the error message')
      expect(status.retry_after).to eq(10)
    end

    it 'should not throw error during deserialization if unknown status was provided' do
      response_json = {
          'status' => 'Provisioning',
          'error' => nil,
          'retryAfter' => 5
      }

      status = AsyncOperationStatus.deserialize_object response_json

      expect(status.status).to eq('Provisioning')
      expect(status.error).to be_nil
      expect(status.retry_after).to eq(5)
    end
  end

end