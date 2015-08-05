# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents an error meaning that either HTTP request or HTTP response was invalid.
  #
  class HttpOperationException < StandardError

    # @return [Net::HTTPRequest] the HTTP request object.
    attr_accessor :request

    # @return [Net::HTTPResponse] the HTTP response object.
    attr_accessor :response

    # @return [String] the HTTP response body.
    attr_accessor :body

    #
    # Creates and initialize new instance of the HttpOperationException class.
    # @param [Net::HTTPRequest] request the HTTP request object.
    # @param [Net::HTTPResponse] response the HTTP response object.
    # @param [String] body the HTTP response body.
    def initialize(request, response, body = nil)
      @request = request
      @response = response
      @body = body
    end

  end
end
