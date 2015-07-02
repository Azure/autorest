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

  	def initialize(azure_response, retry_timeout)
  	  timeout = retry_timeout
  	  request = azure_response.request
  	  response = azure_response.response
  	  resource = azure_response.body

  	  if (!resource.nil? && !resource.provisioning_state.nil?)
  	  	status = resource.provisioning_state
  	  else
  	  	case response.code
  	  	  when 202
  	  	    status = AsyncOperationStatus::In_progress_status
  	  	  when 200, 201, 2014
  	  	    status = AsyncOperationStatus::Success_status
  	  	  else
  	  	  	status = AsyncOperationStatus::Failed_status
  	  	  end
  	  end
  	end

   private

   attr_accessor :timeout

  end

end