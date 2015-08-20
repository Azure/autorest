# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class that provides access to authentication token.
  #
  class StringTokenProvider < TokenProvider

    private

    # @return [String] the access token.
    attr_accessor :token

    # @return [String] the token type.
    attr_accessor :token_type

    public

    #
    # Creates and initalizes a new instance of StringTokenProvider class.

    # @param token [String] the access token.
    # @param token_type [String] the token type.
    #
    def initialize(token, token_type = TokenCredentials::DEFAULT_SCHEME)
      @token = token
      @token_type = token_type
    end

    #
    # Returns the string value which needs to be attached
    # to HTTP request header in order to be authorized.
    #
    # @return [String] authentication headers.
    def get_authentication_header
      "#{token_type} #{token}"
    end
  end
end
