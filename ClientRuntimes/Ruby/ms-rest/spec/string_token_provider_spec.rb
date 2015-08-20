# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest

  describe StringTokenProvider do
    it 'should use default scheme for header' do
      token_provider = StringTokenProvider.new('the_token')
      expect(token_provider.get_authentication_header).to eq('Bearer the_token')
    end

    it 'should use given scheme for header' do
      token_provider = StringTokenProvider.new('the_token', 'the_scheme')
      expect(token_provider.get_authentication_header).to eq('the_scheme the_token')
    end
  end

end