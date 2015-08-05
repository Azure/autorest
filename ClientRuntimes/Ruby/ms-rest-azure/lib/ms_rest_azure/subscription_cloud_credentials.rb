# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an Azure error.
  #
  class SubscriptionCloudCredentials < MsRest::ServiceClientCredentials

    # @return [String] the subscription id.
    attr_accessor :subscriptionId
  end
end
