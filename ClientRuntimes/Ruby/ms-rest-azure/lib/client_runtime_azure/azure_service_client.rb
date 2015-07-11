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
    # @param azure_response [] TODO
    # @param get_operation_block [] TODO
    # @param custom_headers [] [description]
    #
    # @return [] TODO.
    def get_put_operation_result(azure_response, get_operation_block, custom_headers, custom_deserialization_block)
      fail ArgumentError if azure_response.nil?
      fail ArgumentError if get_operation_block.nil?

      if (azure_response.response.code != "200" &&
          azure_response.response.code != "201" &&
          azure_response.response.code != "202")
        fail ArgumentError
      end

      polling_state = PollingState.new(azure_response, 1) # TODO: add timeout

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          if !polling_state.azure_async_operation_header_link.nil?
            p 'update_state_from_azure_async_operation_header'
            update_state_from_azure_async_operation_header(polling_state, custom_headers, custom_deserialization_block)
          elsif !polling_state.location_header_link.nil?
            p 'update_state_from_location_header_on_put'
            update_state_from_location_header_on_put(polling_state, custom_headers, custom_deserialization_block)
          else
            p 'update_state_from_get_resource_operation'
            update_state_from_get_resource_operation(get_operation_block, polling_state)
          end

          if (AsyncOperationStatus.is_terminal_status(polling_state.status))
            task.shutdown
          end
        end

        task.execution_interval = polling_state.get_delay_in_milliseconds()
        task.execute
        task.wait_for_termination
      end

      promise = Concurrent::Promise.new do
        if (AsyncOperationStatus.is_successful_status(polling_state.status) && polling_state.resource.nil?)
          update_state_from_get_resource_operation(get_operation_block, polling_state)
        end

        if (AsyncOperationStatus.is_failed_status(polling_state.status))
          fail CloudError # TODO: proper error
        end

        polling_state.get_operation_response
      end

      promise.execute
    end

    def get_post_or_delete_operation_result(azure_response, custom_headers, custom_deserialization_block)
      fail ArgumentError if azure_response.nil?
      fail ArgumentError if azure_response.response.nil?

      if (azure_response.response.code != "200" &&
          azure_response.response.code != "201" &&
          azure_response.response.code != "202")
        fail ArgumentError
      end

      polling_state = PollingState.new(azure_response, 1) # TODO: add timeout

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          if !polling_state.azure_async_operation_header_link.nil?
            p 'update_state_from_azure_async_operation_header'
            update_state_from_azure_async_operation_header(polling_state, custom_headers, custom_deserialization_block)
          elsif !polling_state.location_header_link.nil?
            p 'update_state_from_location_header_on_post_or_delete'
            update_state_from_location_header_on_post_or_delete(polling_state, custom_headers, custom_deserialization_block)
          else
            task.shutdown
            fail CloudError
          end

          if (AsyncOperationStatus.is_terminal_status(polling_state.status))
            task.shutdown
          end
        end

        task.execution_interval = polling_state.get_delay_in_milliseconds()
        task.execute
        task.wait_for_termination
      end

      promise = Concurrent::Promise.new do
        if (AsyncOperationStatus.is_failed_status(polling_state.status))
          fail ArgumentError # TODO: proper error
        end

        polling_state.get_operation_response
      end

      promise.execute
    end

    def update_state_from_get_resource_operation(get_operation_block, polling_state)
      result = get_operation_block.call().value!

      if (result.body.respond_to?(:properties) && result.body.properties.respond_to?(:provisioning_state) && !result.body.properties.provisioning_state.nil?)
        polling_state.status = result.body.properties.provisioning_state
      else
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
      end

      # TODO: fill the polling_state.error

      polling_state.update_response(result.response)
      polling_state.request = result.request
      polling_state.resource = result.body
    end

    def update_state_from_location_header_on_put(polling_state, custom_headers, custom_deserialization_block)
      result = get_async(polling_state.location_header_link, custom_headers, custom_deserialization_block).value!

      polling_state.update_response(result.response)
      polling_state.request = result.request

      status_code = result.response.code

      if (status_code == "202")
        polling_state.status = AsyncOperationStatus::IN_PROGRESS_STATUS
      elsif (status_code == "200" || status_code == "201")
        fail ArgumentError if (result.body.nil?)
          # TODO elaborate error

      if (result.body.respond_to?(:properties) && result.body.properties.respond_to?(:provisioning_state) && !result.body.properties.provisioning_state.nil?)
          polling_state.status = result.body.properties.provisioning_state
        else
          polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        end

        # TODO add filling of the polling_state.error

        polling_state.resource = result.body
      end
    end

    def update_state_from_azure_async_operation_header(polling_state, custom_headers, custom_deserialization_block)
      result = get_async(polling_state.azure_async_operation_header_link, custom_headers, custom_deserialization_block).value!

      # TODO elaborate error
      fail ArgumentError if (result.body.nil? || result.body.status.nil?)

      polling_state.status = result.body.status
      # TODO: fill the error
      # polling_state.error = nil
      polling_state.response = result.response
      polling_state.request = result.request
      polling_state.resource = nil
    end

    def update_state_from_location_header_on_post_or_delete(polling_state, custom_headers, custom_deserialization_block)
      result = get_async(polling_state.location_header_link, custom_headers, custom_deserialization_block).value!

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

    #
    # Retrives data by given URL.
    # @param operation_url [String] the URL.
    # @param custom_headers [String] headers to apply to the HTTP request.
    # @param custom_deserialization_block [Proc] function to perform deserialization of the HTTP response.
    #
    # @return [type] [description]
    def get_async(operation_url, custom_headers, custom_deserialization_block)
      fail ArgumentError if operation_url.nil?

      # TODO: add url encoding.
      url = URI(operation_url)

      # Create HTTP transport objects
      http_request = Net::HTTP::Get.new(url.request_uri)
      http_request.add_field('Content-Type', 'application/json')

      # TODO: add custom headers

      # Send Request
      promise = Concurrent::Promise.new { self.make_http_request(http_request, url) }

      promise = promise.then do |http_response|
        status_code = http_response.code.to_i
        response_content = http_response.body

        if (status_code != 200 && status_code != 201 && status_code != 202 && status_code != 204)
          fail CloudError
        end

        result = ClientRuntime::HttpOperationResponse.new(http_request, http_response, http_response.body)

        parsed_response = JSON.load(response_content) unless response_content.to_s.empty?
        if (parsed_response && !custom_deserialization_block.nil?)
          parsed_response = custom_deserialization_block.call(parsed_response)
        end

        result.body = parsed_response

        result
      end

      promise.execute
    end
  end

end
