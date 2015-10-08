# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents the data received and deserialized from Azure service.
  #
  class AzureOperationResponse < MsRest::HttpOperationResponse

    # @return [String] identificator of the request.
    attr_accessor :request_id
  end
end
