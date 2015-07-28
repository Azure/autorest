# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents a state of Azure long running operation.
  #
  class PollingState

    # @return [Net::HTTPRequest] the HTTP request.
  	attr_accessor :request

    # @return the resource
  	attr_accessor :resource

    # @return [Net::HTTPResponse] the HTTP response.
    attr_accessor :response

    # @return [String] the latest value captured from Azure-AsyncOperation header.
    attr_accessor :azure_async_operation_header_link

    # @return [String] the latest value captured from Location header.
    attr_accessor :location_header_link

    # @return [String] status of the long running operation.
    attr_accessor :status

  	def initialize(azure_response, retry_timeout)
  	  @retry_timeout = retry_timeout
  	  @request = azure_response.request
  	  update_response(azure_response.response)
  	  @resource = azure_response.body

  	  if (!@resource.nil? && @resource.respond_to?(:properties) && @resource.properties.respond_to?(:provisioning_state) && !@resource.properties.provisioning_state.nil?)
  	  	@status = @resource.properties.provisioning_state
  	  else
  	  	case @response.status
  	  	  when 202
  	  	    @status = AsyncOperationStatus::IN_PROGRESS_STATUS
  	  	  when 200, 201, 204
  	  	    @status = AsyncOperationStatus::SUCCESS_STATUS
  	  	  else
  	  	  	@status = AsyncOperationStatus::FAILED_STATUS
  	  	  end
  	  end
  	end

    #
    # Returns the amount of time in milliseconds for long running operation polling dealy.
    #
    # @return [Integer] Amount of time in milliseconds for long running operation polling dealy.
    def get_delay_in_milliseconds
      return @retry_timeout unless @retry_timeout.nil?

      if (!response.nil? && !response['Retry-After'].nil?)
        return response['Retry-After'].to_i * 1000
      end

      return MsRestAzure::AzureAsyncOperation.DEFAULT_DELAY
    end

    #
    # Updates the polling state from the fields of given response object.
    # @param response [Net::HTTPResponse] the HTTP response.
    def update_response(response)
      @response = response

      if (!response.nil?)
        @azure_async_operation_header_link = response['Azure-AsyncOperation'] unless response['Azure-AsyncOperation'].nil?
        @location_header_link = response['Location'] unless response['Location'].nil?
      end
    end

    #
    # returns the Azure's response.
    #
    # @return [MsRestAzure::AzureOperationResponse] Azure's response.
    def get_operation_response
      azure_response = AzureOperationResponse.new(@request, @response, @resource)
      azure_response
    end

    private

    # @return [Integer] retry timeout.
    attr_accessor :retry_timeout
  end

end