# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents an Azure token credentials.
  #
  class TokenCloudCredentials < SubscriptionCloudCredentials

  	DEFAULT_SCHEME = 'Bearer'

    # @return [String] the subscription id.
    attr_accessor :subscriptionId

    # @return [String] auth token
    attr_accessor :token

    def initialize(subscriptionId, token)
      fail ArgumentError if subscriptionId.nil?
      fail ArgumentError if token.nil?

      @subscriptionId = subscriptionId
      @token = token
    end

    #
    # Attaches OAuth authentication header to the given HTTP request.
    # @param request [Net::HTTPRequest] the request authentication header needs to be attached to.
    #
    # @return [Net::HTTPRequest] request with attached authentication header
    def sign_request(request)
      super(request)
      credentials = "#{DEFAULT_SCHEME} #{token}"
      request.add_field(AUTHORIZATION, credentials)
    end
  end
end
