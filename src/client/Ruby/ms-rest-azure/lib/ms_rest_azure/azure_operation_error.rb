# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an Azure error.
  #
  class AzureOperationError < MsRest::HttpOperationError

    # @return [String] the error message.
    attr_accessor :error_message

    # @return [String] the error code.
    attr_accessor :error_code

    #
    # Creates and initialize new instance of the AzureOperationError class.
    # @param [Hash] the HTTP request data (uri, body, headers).
    # @param [Faraday::Response] the HTTP response object.
    # @param [String] body the HTTP response body.
    # @param [String] error message.
    #
    def initialize(*args)
      super(*args)

      # Try to parse @body to find useful error message and code
      # Body should meet the error condition response requirements for Microsoft REST API Guidelines
      # https://github.com/Microsoft/api-guidelines/blob/master/Guidelines.md#7102-error-condition-responses
      begin
        unless @body.nil?
          @error_message = @body['error']['message']
          @error_code = @body['error']['code']
          @msg = "#{@msg}: #{@error_code}: #{@error_message}"
        end
      rescue
      end
    end
  end
end
