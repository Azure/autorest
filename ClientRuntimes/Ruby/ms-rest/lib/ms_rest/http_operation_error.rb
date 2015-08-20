# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents an error meaning that either HTTP request or HTTP response was invalid.
  #
  class HttpOperationError < RestError

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
    # @param [String] error message.
    def initialize(*args)
      if args.size == 1
        # When only message is provided.
        super(args[0])
      elsif args.size == 2
        # When only request and response provided, body is nil.
        @request = args[0]
        @response = args[1]
        @body = nil
        super()
      elsif args.size == 3
        # When request, response and body were provided.
        @request = args[0]
        @response = args[1]
        @body = args[2]
        super()
      elsif args.size == 4
        # When request, response, body and message were provided.
        @request = args[0]
        @response = args[1]
        @body = args[2]
        super(args[3])
      else
        fail ArgumentError, 'Invalid number of arguments was provided, valid number: 1, 2, 3 or 4'
      end
    end
  end

end
