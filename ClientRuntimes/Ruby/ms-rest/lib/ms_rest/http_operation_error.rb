# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
require 'json'

module MsRest
  #
  # Class which represents an error meaning that either HTTP request or HTTP response was invalid.
  #
  class HttpOperationError < RestError

    # @return [Hash] the HTTP request data (uri, body, headers).
    attr_accessor :request

    # @return [Faraday::Response] the HTTP response object.
    attr_accessor :response

    # @return [String] the HTTP response body.
    attr_accessor :body

    #
    # Creates and initialize new instance of the HttpOperationException class.
    # @param [Hash] the HTTP request data (uri, body, headers).
    # @param [Faraday::Response] the HTTP response object.
    # @param [String] body the HTTP response body.
    # @param [String] error message.
    def initialize(*args)
      @msg = self.class.name
      if args.size == 1
        # When only message is provided.
        @msg = args[0]
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
        @msg = args[3]
        super(args[3])
      else
        fail ArgumentError, 'Invalid number of arguments was provided, valid number: 1, 2, 3 or 4'
      end
    end
    
    def to_json(*a)
      res_dict = response ? { body: response.body, headers: response.headers, status: response.status } : nil
      {message: @msg, request: request, response: res_dict}.to_json(*a)
    end
    
    def to_s
      begin
        JSON.pretty_generate(self)
      rescue Exception => ex
        "#{self.class.name} failed in \n\t#{backtrace.join("\n\t")}"
      end
    end
  end

end
