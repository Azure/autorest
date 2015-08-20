# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which keeps functionality and date for performing OAuth (token based) authentication.
  #
  class TokenCredentials < ServiceClientCredentials

    private

    DEFAULT_SCHEME = 'Bearer'

    # @return [String] the scheme for arranging token in the HTTP header.
    attr_accessor :token_provider

    public

    #
    # Creates and initialize new instance of the TokenCredentials class.
    # @param token_provider [TokenProvider] the token provider.
    # @param token [String] the token.
    def initialize(*args)
      if (args.size == 1)
        if args[0].respond_to? :get_authentication_header
          @token_provider = args[0]
        elsif args[0].is_a? String
          @token_provider = StringTokenProvider.new args[0], DEFAULT_SCHEME
        else
          fail ArgumentError, 'Invalid argument was passed, is can be either TokenProvider or token'
        end
      elsif (args.size == 2)
        token = args[0]
        token_type = args[1]
        @token_provider = StringTokenProvider.new token, token_type
      else
        fail ArgumentError, 'Invalid number of parameters was passed to TokenCredentials constructor, valid number is 1 or 2'
      end
    end

    #
    # Attaches OAuth authentication header to the given HTTP request.
    # @param request [Net::HTTPRequest] the request authentication header needs to be attached to.
    #
    # @return [Net::HTTPRequest] request with attached authentication header
    def sign_request(request)
      super(request)
      header = @token_provider.get_authentication_header

      if (request.respond_to?(:request_headers))
        request.request_headers[AUTHORIZATION] = header
      elsif request.respond_to?(:headers)
        request.headers[AUTHORIZATION] = header
      else
        fail ArgumentError, 'Incorrect request object was provided'
      end
    end

  end
end
