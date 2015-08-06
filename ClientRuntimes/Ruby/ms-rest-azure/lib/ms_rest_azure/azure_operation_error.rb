# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an Azure error.
  #
  class AzureOperationError < MsRest::HttpOperationError
    #
    # Creates and initialize new instance of the HttpOperationException class.
    # @param [Net::HTTPRequest] request the HTTP request object.
    # @param [Net::HTTPResponse] response the HTTP response object.
    # @param [String] body the HTTP response body.
    # @param [String] error message.
    def initialize(*args)
      if (args.size == 1)
        # When only message is provided.
        @message = args[0]
      elsif (args.size == 3)
        # When request, response and body were provided.
        super(*args)
      elsif (args.size == 4)
        # When request, response, body and message were provided.
        super(*args[0...-1])
        @message = args[3]
      else
        fail ArgumentError, 'Invalid number of arguments was provided to AzureOperationError, valid number: 1, 3 or 4'
      end
    end
  end
end
