# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an Azure error.
  #
  class AzureOperationError < MsRest::HttpOperationError

    def to_s
      # Try to parse @body to find error message and set @msg
      begin
        unless @body.nil?
          # Body should meet the error condition response requirements for Microsoft REST API Guidelines
          # https://github.com/Microsoft/api-guidelines/blob/master/Guidelines.md#7102-error-condition-responses
          @msg = @body['error']['message']
        end
      rescue
      end

      super
    end
  end
end
