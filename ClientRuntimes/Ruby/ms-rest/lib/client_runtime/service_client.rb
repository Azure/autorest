# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntime
  #
  # Class which represents a point of access to the REST API.
  #
  class ServiceClient

    # @return [Hash] custom headers which are attached to the HTTP requests.
    attr_accessor :custom_headers

    # @return [ClientRuntime::ServiceClientCredentials] The credentials object.
    attr_accessor :credentials

    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    def initialize
      @custom_headers = {}
    end

    #
    # Makes the HTTP request by the given uri.
    # @param request [Net::HTTPRequest] the HTTP request to perform.
    # @param uri [URI::HTTP] the URI for HTTP request.
    #
    # @return [Net::HTTPResponse] the HTTP response.
    def make_http_request(request, uri)
      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      # adding custom HTTP headers
      @custom_headers.each do |key, value|
        request.add_field(key, value)
      end

      # sign in
      @credentials.sign_request(request) unless @credentials.nil?

      http.request(request)
    end
  end

end
