# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest

  describe BasicAuthenticationCredentials do
    it 'should throw error if nil data is provided' do
      expect { BasicAuthenticationCredentials.new(nil, 'test') }.to raise_error(ArgumentError)
      expect { BasicAuthenticationCredentials.new('test', nil) }.to raise_error(ArgumentError)
      expect { BasicAuthenticationCredentials.new('test', 'test', nil) }.to raise_error(ArgumentError)
    end

    it 'should throw error if nil request object is provided' do
      credentials = BasicAuthenticationCredentials.new('test', 'test')
      expect { credentials.sign_request(nil) }.to raise_error(ArgumentError)
    end

    it 'should throw error if incorrect request object is provided' do
      credentials = BasicAuthenticationCredentials.new('test', 'test')
      expect { credentials.sign_request('this is not HTTP request') }.to raise_error(ArgumentError)
    end

    it 'should sign request with default scheme' do
      http_request = double('http_request', :headers => {})

      credentials = BasicAuthenticationCredentials.new('test_username', 'test_password')
      credentials.sign_request(http_request)

      expect(http_request.headers['authorization']).to eq('Basic dGVzdF91c2VybmFtZTp0ZXN0X3Bhc3N3b3Jk')
    end

    it 'should sign request with given scheme' do
      http_request = double('http_request', :headers => {})

      credentials = BasicAuthenticationCredentials.new('test_username', 'test_password', 'test_scheme')
      credentials.sign_request(http_request)

      expect(http_request.headers['authorization']).to eq('test_scheme dGVzdF91c2VybmFtZTp0ZXN0X3Bhc3N3b3Jk')
    end
  end

end