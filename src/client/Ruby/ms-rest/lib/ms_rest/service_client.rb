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

  #
  # Hash of SSL options for Faraday connection. Default is nil.
  #
  @@ssl_options = nil

  #
  # Stores the SSL options to be used for Faraday connections.
  # ==== Examples
  #   MsRest.use_ssl_cert                                  # => Uses bundled certificate for all the connections
  #   MsRest.use_ssl_cert({:ca_file => "path_to_ca_file"}) # => Uses supplied certificate for all the connections
  #
  # @param ssl_options [Hash] Hash of SSL options for Faraday connection. It defaults to the bundled certificate.
  #
  def self.use_ssl_cert(ssl_options = nil)
    if ssl_options.nil?
      @@ssl_options = {:ca_file => File.expand_path(File.join(File.dirname(__FILE__), '../..', 'ca-cert.pem')) }
    else
      @@ssl_options = ssl_options
    end
  end

  #
  # @return [Hash] Hash of SSL options to be used for Faraday connection.
  #
  def self.ssl_options
    @@ssl_options
  end
end
