# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which keeps functionality and data for performing HTTP basic authentication.

  #
  class BasicAuthenticationCredentials < ServiceClientCredentials

    private

    DEFAULT_SCHEME = 'Basic'

    # @return [String] the scheme for composing credentials.
    attr_accessor :scheme

    # @return [String] the username for authentication.
    attr_accessor :user_name

    # @return [String] password for authentication.
    attr_accessor :password

    public

    #
    # Creates and initialize new instance of the BasicAuthenticationCredentials class.
    # @param user_name [String] the username for authentication.
    # @param password [String] the password for authentication.
    # @param scheme = DEFAULT_SCHEME [String] the scheme for composing credentials.
    def initialize(user_name, password, scheme = DEFAULT_SCHEME)
      fail ArgumentError, 'user_name cannot be nil' if user_name.nil?
      fail ArgumentError, 'password cannot be nil' if password.nil?
      fail ArgumentError, 'scheme cannot be nil' if scheme.nil?

      @user_name = user_name
      @password = password
      @scheme = scheme
    end

    #
    # Attaches basic authentication header to the given HTTP request.
    # @param request [Net::HTTPRequest] the request authentication header needs to be attached to.
    #
    # @return [Net::HTTPRequest] request with attached authentication header.
    def sign_request(request)
      super(request)
      encodeCredentials = Base64.strict_encode64("#{user_name}:#{password}")
      credentials = "#{scheme} #{encodeCredentials}"

      if (request.respond_to?(:request_headers))
        request.request_headers[AUTHORIZATION] = credentials
      elsif request.respond_to?(:headers)
        request.headers[AUTHORIZATION] = credentials
      else
        fail ArgumentError, 'Incorrect request object was provided'
      end
    end

  end
end
