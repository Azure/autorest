# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest

  describe ServiceClientCredentials do
    it 'should throw error if request for signing is nil' do
      credentials = ServiceClientCredentials.new
      expect { credentials.sign_request nil }.to raise_error(ArgumentError)
    end
  end

end