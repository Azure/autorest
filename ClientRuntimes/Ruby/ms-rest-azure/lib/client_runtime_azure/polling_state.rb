# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Class which represents a state of Azure long running operation.
  #
  class PollingState
  	attr_accessor :response

  	attr_accessor :request

  	attr_accessor :resource

  	attr_accessor :status

    attr_accessor :azure_async_operation_header_link

    attr_accessor :location_header_link

  	def initialize(azure_response, retry_timeout)
  	  @timeout = retry_timeout
  	  @request = azure_response.request
  	  @response = azure_response.response
  	  @resource = azure_response.body

  	  if (!@resource.nil? && !@resource.provisioning_state.nil?)
  	  	@status = @resource.provisioning_state
  	  else
  	  	case @response.code
  	  	  when "202"
  	  	    @status = AsyncOperationStatus::IN_PROGRESS_STATUS
  	  	  when "200", "201", "204"
  	  	    @status = AsyncOperationStatus::SUCCESS_STATUS
  	  	  else
  	  	  	@status = AsyncOperationStatus::FAILED_STATUS
  	  	  end
  	  end
  	end

    def get_timeout()
      # TODO
      return 1
    end

    #
    # Updates the polling state from the fields of given response object.
    # @param response [Net::HTTPResponse] the HTTP response.
    def update_response(response)
      @response = response

      if (!response.nil?)
        @azure_async_operation_header_link = response['azure-asyncoperation']
        @location_header_link = response['location']
      end
    end

   private

   attr_accessor :timeout

  end

end