# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents the data received and deserialized from server.
  #
  class HttpOperationResponse

    # @param [Hash] the HTTP request data (uri_prefix:, body:, headers:, params:, path:).
    attr_accessor :request

    # @return [Faraday::Response] the HTTP response object.
    attr_accessor :response

    # @return [String] the HTTP response body.
    attr_accessor :body

    #
    # Creates and initialize new instance of the HttpOperationResponse class.
    # @param [Hash] request the HTTP request object.
    # @param [Faraday::Response] response the HTTP response object.
    # @param [String] body the HTTP response body.
    def initialize(request, response, body = nil)
      @request = request
      @response = response
      @body = body
    end

  end
end
