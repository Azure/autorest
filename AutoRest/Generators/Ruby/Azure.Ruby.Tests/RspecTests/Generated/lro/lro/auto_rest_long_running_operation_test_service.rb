# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module LroModule
  #
  # A service client - single point of access to the REST API.
  #
  class AutoRestLongRunningOperationTestService < MsRestAzure::AzureServiceClient
    include LroModule::Models
    include MsRestAzure

    # @return [String] the base URI of the service.
    attr_accessor :base_url

    # @return The management credentials for Azure.
    attr_reader :credentials

    # @return [String] Gets or sets the preferred language for the response.
    attr_accessor :accept_language

    # @return [Integer] The retry timeout for Long Running Operations.
    attr_accessor :long_running_operation_retry_timeout

    # @return Subscription credentials which uniquely identify client
    # subscription.
    attr_accessor :credentials

    # @return lros
    attr_reader :lros

    # @return lroretrys
    attr_reader :lroretrys

    # @return lrosads
    attr_reader :lrosads

    # @return lros_custom_header
    attr_reader :lros_custom_header

    #
    # Creates initializes a new instance of the AutoRestLongRunningOperationTestService class.
    # @param credentials [MsRest::ServiceClientCredentials] credentials to authorize HTTP requests made by the service client.
    # @param base_url [String] the base URI of the service.
    # @param options [Array] filters to be applied to the HTTP requests.
    #
    def initialize(credentials, base_url = nil, options = nil)
      super(credentials, options)
      @base_url = base_url || 'http://localhost'

      fail ArgumentError, 'credentials is nil' if credentials.nil?
      fail ArgumentError, 'invalid type of credentials input parameter' unless credentials.is_a?(MsRest::ServiceClientCredentials)
      @credentials = credentials

      @lros = LROs.new(self)
      @lroretrys = LRORetrys.new(self)
      @lrosads = LROSADs.new(self)
      @lros_custom_header = LROsCustomHeader.new(self)
      @accept_language = "en-US"
    end

  end
end
