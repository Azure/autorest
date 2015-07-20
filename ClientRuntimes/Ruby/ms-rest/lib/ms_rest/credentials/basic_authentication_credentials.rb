# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which keeps functionality and data for performing HTTP basic authentication.

  #
  class BasicAuthenticationCredentials < ServiceClientCredentials

    DEFAULT_SCHEME = 'Basic'

    # @return [String] the scheme for composing credentials.
    attr_accessor :scheme

    # @return [String] the username for authentication.
    attr_accessor :user_name

    # @return [String] password for authentication.
    attr_accessor :password

    #
    # Creates and initialize new instance of the BasicAuthenticationCredentials class.
    # @param scheme = DEFAULT_SCHEME [String] the scheme for composing credentials.
    # @param user_name [String] the username for authentication.
    # @param password [String] the password for authentication.
    def initialize(scheme = DEFAULT_SCHEME, user_name, password)
      @scheme = scheme
      @user_name = user_name
      @password = password
    end

    #
    # Attaches basic authentication header to the given HTTP request.
    # @param request [Net::HTTPRequest] the request authentication header needs to be attached to.
    #
    # @return [Net::HTTPRequest] request with attached authentication header.
    def sign_request(request)
      super(request)
      encodeCredentials = Base64.encode64("#{user_name}:#{password}").chomp
      credentials = "#{scheme} #{encodeCredentials}"
      request.add_field(AUTHORIZATION, credentials)
    end

  end
end
