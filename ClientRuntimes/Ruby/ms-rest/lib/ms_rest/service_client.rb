# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which represents a point of access to the REST API.
  #
  class ServiceClient

    # @return [MsRest::ServiceClientCredentials] the credentials object.
    attr_accessor :credentials

    # @return [Array] filters to be applied to the HTTP requests.
    attr_accessor :options

    # @return [String] value of cookies.
    attr_accessor :cookies

    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    # @param credentials [MsRest::ServiceClientCredentials] credentials to authorize
    # HTTP requests made by the service client.
    # @param options [Array] filters to be applied to the HTTP requests.
    #
    def initialize(credentials, options)
      @credentials = credentials
      @options = options
    end
  end

end
