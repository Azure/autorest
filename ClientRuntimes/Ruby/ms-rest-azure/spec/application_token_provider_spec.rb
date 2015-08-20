# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure

  describe ApplicationTokenProvider do
    it 'should throw error if nil data is passed into constructor' do
      expect { ApplicationTokenProvider.new(nil, 'client_id', 'client_secret') }.to raise_error(ArgumentError)
      expect { ApplicationTokenProvider.new('tenant_id', nil, 'client_secret') }.to raise_error(ArgumentError)
      expect { ApplicationTokenProvider.new(nil, 'client_id', nil) }.to raise_error(ArgumentError)
      expect { ApplicationTokenProvider.new(nil, 'client_id', 'client_secret', nil) }.to raise_error(ArgumentError)
    end
  end

end