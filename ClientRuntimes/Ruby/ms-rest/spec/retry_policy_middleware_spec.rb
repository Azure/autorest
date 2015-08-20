# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest

  describe RetryPolicyMiddleware do
    def make_http_request(response_stubs)
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        response_stubs.each do |response_stub|
          stub.get('/url') { |env| response_stub }
        end
      end

      test = Faraday.new do |builder|
        builder.use MsRest::RetryPolicyMiddleware
        builder.adapter :test, stubs
      end

      test.get '/url'
    end

    it 'should retry request for specific HTTP codes' do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/url') { |env| [500, {}, ''] }
        stub.get('/url') { |env| [502, {}, ''] }
        stub.get('/url') { |env| [408, {}, ''] }
        stub.get('/url') { |env| [200, {}, ''] }
      end

      test = Faraday.new do |builder|
        builder.use MsRest::RetryPolicyMiddleware, times: 3
        builder.adapter :test, stubs
      end

      response = test.get '/url'
      expect(response.status).to eq(200)
    end

    it 'should not retry request for NotFound response' do
      response = make_http_request([[404], [200]])
      expect(response.status).to eq(404)
    end

    it 'should not retry request for NotImplemented response' do
      response = make_http_request([[501], [200]])
      expect(response.status).to eq(501)
    end

    it 'should not retry request for VersionNotSupported response' do
      response = make_http_request([[505], [200]])
      expect(response.status).to eq(505)
    end

    it 'should not retry request for OK response' do
      response = make_http_request([[200, {}, 'response1'], [200, {}, 'response2']])
      expect(response.status).to eq(200)
      expect(response.body).to eq('response1')
    end

    it 'should not retry more than given number of times' do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/url') { |env| [500] }
        stub.get('/url') { |env| [500] }
        stub.get('/url') { |env| [500] }
        stub.get('/url') { |env| [200] }
      end

      test = Faraday.new do |builder|
        builder.use MsRest::RetryPolicyMiddleware, times: 2
        builder.adapter :test, stubs
      end

      response = test.get '/url'
      expect(response.status).to eq(500)
    end
  end

end