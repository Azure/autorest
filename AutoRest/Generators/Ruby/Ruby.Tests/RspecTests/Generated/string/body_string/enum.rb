# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module StringModule
  #
  # Test Infrastructure for AutoRest Swagger BAT
  #
  class Enum
    include StringModule::Models

    #
    # Creates and initializes a new instance of the Enum class.
    # @param client service class for accessing basic functionality.
    #
    def initialize(client)
      @client = client
    end

    # @return reference to the AutoRestSwaggerBATService
    attr_reader :client

    #
    # Get enum value 'red color' from enumeration of 'red color', 'green-color',
    # 'blue_color'.
    #
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def get_not_expandable(custom_headers = nil)
      # Construct URL
      path = "/string/enum/notExpandable"
      url = URI.join(@client.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          @client.credentials.sign_request(request) unless @client.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200)
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(connection, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
            if (!parsed_response.nil? && !parsed_response.empty?)
              enum_is_valid = Colors.constants.any? { |e| Colors.const_get(e).to_s.downcase == parsed_response.downcase }
              fail MsRest::DeserializationError.new('Error occured while deserializing the enum', nil, nil, nil) unless enum_is_valid
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, response_content)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Sends value 'red color' from enumeration of 'red color', 'green-color',
    # 'blue_color'
    #
    # @param string_body [Colors] Possible values for this parameter include: 'red
    # color', 'green-color', 'blue_color'
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def put_not_expandable(string_body, custom_headers = nil)
      fail ArgumentError, 'string_body is nil' if string_body.nil?
      # Construct URL
      path = "/string/enum/notExpandable"
      url = URI.join(@client.base_url, path)
      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/
      corrected_url = url.to_s.gsub(/([^:])\/\//, '\1/')
      url = URI.parse(corrected_url)

      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end
      request_headers = Hash.new

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Serialize Request
      request_headers['Content-Type'] = 'application/json; charset=utf-8'
      request_content = JSON.generate(string_body, quirks_mode: true)

      # Send Request
      promise = Concurrent::Promise.new do
        connection.put do |request|
          request.headers = request_headers
          request.body = request_content
          @client.credentials.sign_request(request) unless @client.credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless (status_code == 200)
          error_model = JSON.load(response_content)
          fail MsRest::HttpOperationError.new(connection, http_response, error_model)
        end

        # Create Result
        result = MsRest::HttpOperationResponse.new(connection, http_response)

        result
      end

      promise.execute
    end

  end
end
