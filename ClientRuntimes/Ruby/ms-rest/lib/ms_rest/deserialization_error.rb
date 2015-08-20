# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents an error happening during deserialization of server response.
  #
  class DeserializationError < RestError

    # @return [String] the human readable description of error.
    attr_accessor :message

    # @return [String] the inner exception message.
    attr_accessor :exception_message

    # @return [String] the inner exception stacktrace.
    attr_accessor :exception_stacktrace

    # @return [String] server response which client was unable to parse.
    attr_accessor :response_body

    #
    # Creates and initialize new instance of the DeserializationError class.
    # @param [String] message message the human readable description of error.
    # @param [String] exception_message the inner exception stacktrace.
    # @param [String] exception_stacktrace the inner exception stacktrace.
    # @param [String] response_body server response which client was unable to parse.
    def initialize(message, exception_message, exception_stacktrace, response_body)
      @message = message
      @exception_message = exception_message
      @exception_stacktrace = exception_stacktrace
      @response_body = response_body
    end

  end
end
