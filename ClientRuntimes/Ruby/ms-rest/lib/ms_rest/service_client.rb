# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents a point of access to the REST API.
  #
  class ServiceClient

    # @return [MsRest::ServiceClientCredentials] the credentials object.
    attr_accessor :credentials

    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    # @param credentials [MsRest::ServiceClientCredentials] credentials to authorize
    # HTTP requests made by the service client.
    # @param options additional parameters for the HTTP request (not implemented yet).
    #
    def initialize(credentials, options = nil)
      @credentials = credentials
    end
  end

end
