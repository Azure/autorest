# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure

  describe CloudErrorData do
    it 'should deserialize CloudErrorData correctly' do
      response_json = {
          'code' => 'the code',
          'message' => 'the message'
      }

      data = CloudErrorData.deserialize_object(response_json)

      expect(data.code).to eq('the code')
      expect(data.message).to eq('the message')
    end
  end

end