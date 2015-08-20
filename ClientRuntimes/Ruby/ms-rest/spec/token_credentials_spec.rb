# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest

  describe TokenCredentials do
    it 'should throw error if invalid number of arguments is passed into constructor' do
      expect { TokenCredentials.new }.to raise_error(ArgumentError)
      expect { TokenCredentials.new 1, 2, 3 }.to raise_error(ArgumentError)
    end

    it 'should sign HTTP requests with given token' do
      http_request = double('http_request', :headers => {})

      credentials = TokenCredentials.new 'the_token'
      credentials.sign_request(http_request)

      expect(http_request.headers['authorization']).to eq('Bearer the_token')
    end

    it 'should sign HTTP requests with given token and scheme' do
      http_request = double('http_request', :headers => {})

      credentials = TokenCredentials.new 'the_token', 'the_scheme'
      credentials.sign_request(http_request)

      expect(http_request.headers['authorization']).to eq('the_scheme the_token')
    end

    it 'should sign HTTP request with given custom token provider' do
      http_request = double('http_request', :headers => {})
      custom_token_provider = double('custom_token_provider')
      allow(custom_token_provider).to receive(:get_authentication_header) { 'custom_token'}

      credentials = TokenCredentials.new custom_token_provider
      credentials.sign_request(http_request)

      expect(http_request.headers['authorization']).to eq('custom_token')
    end
  end

end