# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Base class for Ruby connections
  #
  # Provides methods to make get, put, post, patch, delete requests.
  class Connection

    def self.operation_response_type
      'MSRest::HttpOperationResponse'
    end

    # @param method [Symbol] with any of the following values :get, :put, :post, :patch, :delete
    # @param url [String] url for the request
    # @param options [Hash{String=>String}] specifying any request options like :body
    def self.request(method, url, options)
      middlewares = {middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]]}
      options = middlewares.merge(options)
      request  = MsRest::HttpOperationRequest.new(options[:api_endpoint], url, method, options)
      promise = request.run_promise do |req|
        options[:credentials].sign_request(req) unless options[:credentials].nil?
      end
      promise = promise.then do |http_response|
        response_content = http_response.body.to_s.empty? ? nil : http_response.body
        # Create Result
        result = Module.const_get(operation_response_type).new(request, http_response)
        result.body = response_content #parsed_response
        result
      end
      promise.execute
    end

  end
  
end
