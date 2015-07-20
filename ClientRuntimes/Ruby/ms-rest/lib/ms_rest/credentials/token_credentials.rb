# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which keeps functionality and date for performing OAuth (token based) authentication.
  #
  class TokenCredentials < ServiceClientCredentials

    DEFAULT_SCHEME = 'Bearer'

    # @return [String] the scheme for arranging token in the HTTP header.
    attr_accessor :scheme

    # @return [String] the token for authentication.
    attr_accessor :token

    #
    # Creates and initialize new instance of the TokenCredentials class.
    # @param scheme = DEFAULT_SCHEME [String] scheme the scheme for arranging token in the HTTP header.
    # @param token [String] token the token for authentication.
    #
    # @return [MsRest::TokenCredentials] A new instance of credentials object.
    def initialize(scheme = DEFAULT_SCHEME, token)
      @scheme = scheme
      @token = token
    end

    #
    # Attaches OAuth authentication header to the given HTTP request.
    # @param request [Net::HTTPRequest] the request authentication header needs to be attached to.
    #
    # @return [Net::HTTPRequest] request with attached authentication header
    def sign_request(request)
      super(request)
      credentials = "#{scheme} #{token}"
      request.add_field(AUTHORIZATION, credentials)
    end

  end
end
