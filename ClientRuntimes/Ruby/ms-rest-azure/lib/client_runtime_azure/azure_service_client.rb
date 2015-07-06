# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Class which represents a point of access to the REST API.
  #
  class AzureServiceClient < ClientRuntime::ServiceClient

    # @return [String] api version of the Azure in string format.
    attr_accessor :api_version

    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    def initialize(credentials, options)
      super(credentials, options)
      @api_version = '2015-05-01-preview'
    end

    #
    # Retrieves the result of 'PUT' operation result. Includes polling of required.
    # @param request [] TODO
    # @param uri [] TODO
    #
    # @return [] TODO.
    def get_put_operation_result(azure_response, get_operation_block)
      fail ArgumentError if azure_response.nil?

      if (azure_response.response.code != "200" &&
          azure_response.response.code != "201" &&
          azure_response.response.code != "202")
        fail ArgumentError
      end

      polling_state = PollingState.new(azure_response, 1) # TODO: add timeout

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do

          p polling_state.status
          # p polling_state.response
          # p polling_state.request

          if !polling_state.azure_async_operation_header_link.nil?
            p 'update_state_from_azure_async_operation_header'
            update_state_from_azure_async_operation_header(polling_state)
          elsif !polling_state.location_header_link.nil?
            p 'update_state_from_location_header_on_put'
            update_state_from_location_header_on_put(polling_state)
          else
            p 'update_state_from_get_resource_operation'
            update_state_from_get_resource_operation(get_operation_block, polling_state)
          end

          if (AsyncOperationStatus.is_terminal_status(polling_state.status))
            task.shutdown
          end
        end

        task.execution_interval = polling_state.get_timeout()
        task.execute
        task.wait_for_termination
      end

      if (AsyncOperationStatus.is_successful_status(polling_state.status))
        update_state_from_get_resource_operation(get_operation_block, polling_state)
      end

      if (AsyncOperationStatus.is_failed_status(polling_state.status))
        fail ArgumentError # TODO: proper error
      end

      # TODO: change to AzureOperationResponse
      polling_state.response
    end

    def update_state_from_get_resource_operation(get_operation_block, polling_state)
      result = get_operation_block.call().value!

      p 'from update_state_from_get_resource_operation'
      p result

      begin
        # if (defined? result.body.provisioning_state && !result.body.provisioning_state.nil?)
        #   p result.body.provisioning_state
        #   p 'within pro state'
        #   polling_state.status = result.body.provisioning_state
        # else
          p 'within suc state'
          polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        # end
      rescue Exception => e
        p e
      end

      p polling_state.status

      # TODO: fill the polling_state.error

      polling_state.update_response(result.response)
      polling_state.request = result.request
      polling_state.resource = result.body
    end

    def update_state_from_location_header_on_put(polling_state)
      result = get_async(polling_state.location_header_link).value!

      polling_state.update_response(result.response)
      polling_state.request = result.request

      status_code = result.response.code

      if (status_code == "202")
        polling_state.status = AsyncOperationStatus::IN_PROGRESS_STATUS
      elsif (status_code == "200" || status_code == "201")
        if (result.body.nil?)
          # TODO elaborate error
          fail ArgumentError

          if (!result.body.properties.nil? && !result.body.properties.provisioning_state.nil?)
            polling_state.status = result.body.properties.provisioning_state
          else
            polling_state.status_code = AsyncOperationStatus::SUCCESS_STATUS
          end

          # TODO add filling of the polling_state.error

          polling_state.resource = result.body
        end
      end
    end

    def update_state_from_azure_async_operation_header(polling_state)
      result = get_async(polling_state.azure_async_operation_header_link).value!

      # TODO elaborate error
      fail ArgumentError if (!result.body.nil? || !result.body.status.nil?)

      polling_state.status = result.body.status
      # TODO: fill the error
      polling_state.error = nil
      polling_state.response = result.response
      polling_state.request = result.request
      polling_state.resource = nil
    end

    def update_state_from_location_header_on_post_or_delete(polling_state)
      result = get_async(polling_state.location_header_link).value!

      polling_state.update_response(result.response)
      polling_state.request = result.request

      status_code = result.response.code

      if (status_code == "202")
        polling_state.status = AsyncOperationStatus::IN_PROGRESS_STATUS
      elsif (status_code == "200" || status_code == "201" || status_code == "204")
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = result.response.body
      end
    end

    def get_async(operation_url)
      fail ArgumentError if operation_url.nil?

      # TODO: add url encoding.
      url = operation_url

      # Create HTTP transport objects
      http_request = Net::HTTP::Get.new(url.request_uri)
      http_request.add_field('Content-Type', 'application/json')

      # TODO: mb we need set credentials here.s

      # Send Request
      promise = Concurrent::Promise.new { self.make_http_request(http_request, url) }

      promise = promise.then do |http_response|
        status_code = http_response.code.to_i

        if (status_code != 200 && status_code != 201
            status_code != 201 && status_code != 204)
          fail HttpOperationException
        end

        # TODO deserialize
        result = ClientRuntime::HttpOperationResponse.new(http_request, http_response, http_response.body)

        p result

        result
      end

      result = promise.execute().value!
      result
    end
  end

end
