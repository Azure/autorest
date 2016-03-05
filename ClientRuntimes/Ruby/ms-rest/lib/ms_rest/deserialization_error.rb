# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
require 'json'

module MsRest
  #
  # Class which represents an error happening during deserialization of server response.
  #
  class DeserializationError < RestError

    # @return [String] the inner exception message.
    attr_accessor :exception_message

    # @return [String] the inner exception stacktrace.
    attr_accessor :exception_stacktrace

    # @return [MsRest::HttpOperationResponse] server response which client was unable to parse.
    attr_accessor :result

    #
    # Creates and initialize new instance of the DeserializationError class.
    # @param [String] message message the human readable description of error.
    # @param [String] exception_message the inner exception stacktrace.
    # @param [String] exception_stacktrace the inner exception stacktrace.
    # @param [MsRest::HttpOperationResponse] the request and response
    def initialize(msg, exception_message, exception_stacktrace, result)
      @msg = msg || self.class.name
      @exception_message = exception_message
      @exception_stacktrace = exception_stacktrace
      @result = result
    end
    
    def to_json(*a)
      {exception_message: exception_message, message: @msg,  stacktrace: exception_stacktrace, result: result}.to_json(*a)
    end
    
    def to_s
      JSON.pretty_generate(self)
    end

  end
end
