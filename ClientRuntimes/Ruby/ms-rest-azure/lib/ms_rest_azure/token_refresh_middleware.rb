# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which handles token renewal.
  #
  class TokenRefreshMiddleware < Faraday::Response::Middleware
    #
    # Initializes a new instance of the TokenRefreshMiddleware class.
    #
    def initialize(app, options = nil)
      fail ArgumentError, 'options cannot be nil' if options.nil?
      fail ArgumentError, 'options must contain credentials object' if options[:credentials].nil?
      @credentials = options[:credentials]

      super(app)
    end

    #
    # Verifies whether given response is about authentication token expiration.
    # @param response [Net::HTTPResponse] http response to verify.
    #
    # @return [Bool] true if response is about authentication token expiration, false otherwise.
    def is_token_expired_response(response)
      return false unless response.status == 401

      begin
        response_body = JSON.load(response.body)
        error_code = response_body['error']['code']
        error_message = response_body['error']['message']
      rescue Exception => e
        return false
      end

      return (error_code == 'AuthenticationFailed' && (error_message.start_with?('The access token expiry') || (error_message.start_with?('The access token is missing or invalid'))))
    end

    #
    # Performs request and response processing.
    #
    def call(request_env)
      request_body = request_env[:body]

      begin
        request_env[:body] = request_body
        @app.call(request_env).on_complete do |response_env|
          fail if is_token_expired_response(response_env)
        end
      rescue Exception => e
        @credentials.acquire_token()
        @credentials.sign_request(request_env)
        retry
      end
    end
  end
end