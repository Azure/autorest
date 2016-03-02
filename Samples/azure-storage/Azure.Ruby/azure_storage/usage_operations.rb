# encoding: utf-8

module Petstore
  #
  # The Storage Management Client.
  #
  class UsageOperations
    include Petstore::Models
    include MsRestAzure

    #
    # Creates and initializes a new instance of the UsageOperations class.
    # @param client service class for accessing basic functionality.
    #
    def initialize(client)
      @client = client
    end

    # @return reference to the StorageManagementClient
    attr_reader :client

    #
    # Gets the current usage count and the limit for the resources under the
    # subscription.
    #
    # @param [Hash{String => String}] The hash of custom headers need to be
    # applied to HTTP request.
    #
    # @return [Concurrent::Promise] Promise object which allows to get HTTP
    # response.
    #
    def list(custom_headers = nil)
      fail ArgumentError, '@client.api_version is nil' if @client.api_version.nil?
      fail ArgumentError, '@client.subscription_id is nil' if @client.subscription_id.nil?
      # Construct URL
      path = '/subscriptions/{subscriptionId}/providers/Microsoft.Storage/usages'
      skipEncodingPathParams = {}
      encodingPathParams = {'subscriptionId' => @client.subscription_id}
      skipEncodingPathParams.each{ |key, value| path["{#{key}}"] = value }
      encodingPathParams.each{ |key, value| path["{#{key}}"] = ERB::Util.url_encode(value) }
      path = URI.parse(path)
      params = {'api-version' => @client.api_version}
      params.reject!{ |_, value| value.nil? }
      corrected_url = path.to_s.gsub(/([^:])\/\//, '\1/')
      path = URI.parse(corrected_url)

      base_url = @base_url || @client.base_url
      connection = Faraday.new(:url => base_url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
        if ENV['AZURE_HTTP_LOGGING']
          faraday.response :logger, nil, { :bodies => true }
        end
      end
      request_headers = Hash.new

      # Set Headers
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['accept-language'] = @client.accept_language unless @client.accept_language.nil?

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.url path
          params.each{ |key, value| request.params[key] = value }
          request.headers = request_headers
          @client.credentials.sign_request(request) unless @client.credentials.nil?
        end
      end
      request_info = {
        method: 'GET',
        url_prefix: connection.url_prefix,
        path: path,
        headers: request_headers
      }
       request_info[:params] = params

      promise = promise.then do |http_response|
        status_code = http_response.status
        response_content = http_response.body
        unless status_code == 200
          error_model = JSON.load(response_content)
          fail MsRestAzure::AzureOperationError.new(request_info, http_response, error_model)
        end

        # Create Result
        result = MsRestAzure::AzureOperationResponse.new(request_info, http_response)
        result.request_id = http_response['x-ms-request-id'] unless http_response['x-ms-request-id'].nil?
        # Deserialize Response
        if status_code == 200
          begin
            parsed_response = response_content.to_s.empty? ? nil : JSON.load(response_content)
            unless parsed_response.nil?
              parsed_response = UsageListResult.deserialize_object(parsed_response)
            end
            result.body = parsed_response
          rescue Exception => e
            fail MsRest::DeserializationError.new('Error occurred in deserializing the response', e.message, e.backtrace, response_content)
          end
        end

        result
      end

      promise.execute
    end

  end
end
