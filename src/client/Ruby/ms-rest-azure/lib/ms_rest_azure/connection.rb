# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  # Base module for Azure Ruby http connections.
  #
  # Provides methods to make get, put, post, patch, delete requests.
  class Connection < MsRest::Connection

    def self.operation_response_type
      'MsRestAzure::AzureOperationResponse'
    end
  end
end
