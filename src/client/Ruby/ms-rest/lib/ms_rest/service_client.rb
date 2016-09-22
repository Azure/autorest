# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents a point of access to the REST API.
  #
  class ServiceClient

    # @return [MsRest::ServiceClientCredentials] the credentials object.
    attr_accessor :credentials

    # @return [Hash{String=>String}] default middlewares configuration for requests
    MIDDLE_WARES = {middlewares: [[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02], [:cookie_jar]]}

    # @return [Hash{String=>String}] default request headers for requests
    REQUEST_HEADERS = {}
    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    # @param credentials [MsRest::ServiceClientCredentials] credentials to authorize
    # HTTP requests made by the service client.
    # @param options additional parameters for the HTTP request (not implemented yet).
    #
    def initialize(credentials, options = nil)
      @credentials = credentials
    end

    # @param request_url [String] the base url for api endpoint
    # @param method [Symbol] with any of the following values :get, :put, :post, :patch, :delete
    # @param path [String] the path, relative to {api_endpoint}
    # @param options [Hash{String=>String}] specifying any request options like :body
    # @return [Concurrent::Promise] Promise object which holds the HTTP response.
    #
    def make_request_async(request_url, method, path, options)
      options = MIDDLE_WARES.merge(options)
      request  = MsRest::HttpOperationRequest.new(request_url, path, method, options)
      promise = request.run_promise do |req|
        options[:credentials].sign_request(req) unless options[:credentials].nil?
      end
      promise = promise.then do |http_response|
        response_content = http_response.body.to_s.empty? ? nil : http_response.body
        # Create Result
        result = create_response(request, http_response)
        result.body = response_content #parsed_response
        result
      end
      promise.execute
    end

    #
    # Retrieves a new instance of the HttpOperationResponse class.
    # @param [MsRest::HttpOperationRequest] request the HTTP request object.
    # @param [Faraday::Response] response the HTTP response object.
    # @param [String] body the HTTP response body.
    # @return [MsRest::HttpOperationResponse] the operation response.
    #
    def create_response(request, http_response, body = nil)
      HttpOperationResponse.new(request, http_response, body)
    end
  end

  #
  # Hash of SSL options for Faraday connection. Default is nil.
  #
  @@ssl_options = nil

  #
  # Stores the SSL options to be used for Faraday connections.
  # ==== Examples
  #   MsRest.use_ssl_cert                                  # => Uses bundled certificate for all the connections
  #   MsRest.use_ssl_cert({:ca_file => "path_to_ca_file"}) # => Uses supplied certificate for all the connections
  #
  # @param ssl_options [Hash] Hash of SSL options for Faraday connection. It defaults to the bundled certificate.
  #
  def self.use_ssl_cert(ssl_options = nil)
    if ssl_options.nil?
      @@ssl_options = {:ca_file => File.expand_path(File.join(File.dirname(__FILE__), '../..', 'ca-cert.pem')) }
    else
      @@ssl_options = ssl_options
    end
  end

  #
  # @return [Hash] Hash of SSL options to be used for Faraday connection.
  #
  def self.ssl_options
    @@ssl_options
  end
end
