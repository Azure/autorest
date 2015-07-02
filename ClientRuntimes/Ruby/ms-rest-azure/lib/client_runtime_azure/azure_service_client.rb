# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Class which represents a point of access to the REST API.
  #
  class AzureServiceClient < ServiceClient

    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    def initialize(credentials, options)
    end

    #
    # Retrieves the result of 'PUT' operation result. Includes polling of required.
    # @param request [] TODO
    # @param uri [] TODO
    #
    # @return [] TODO.
    def get_put_operation_result(azure_response, get_operation_block)
      fail ArgumentError if azure_response.nil?

      if (azure_response.response.code != 200 &&
          azure_response.response.code != 201 &&
          azure_response.response.code != 202)
        fail ArgumentError
      end

      polling_state = PollingState.new(azure_response, 1) # TODO: add timeout

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          if polling_state.azure_async_operation_header_link.nil?
            service_client.update_state_from_azure_async_operation_header(polling_state)
          elsif pollingState.location_header_link.nil?
            # TODO await UpdateStateFromLocationHeaderOnPut(client, pollingState, cancellationToken);
          else
            # TODO await UpdateStateFromGetResourceOperation(getOperationAction, pollingState);
          end

          if (AsyncOperationStatus.is_terminal_status(polling_state.status))
            task.shutdown
          end
        end

        task.execution_interval = polling_state.delay_in_milliseconds
        task.execute
        task.wait_for_termination
      end

      if (AsyncOperationStatus.is_successful_status(polling_state.status))
        # TODO await UpdateStateFromGetResourceOperation(getOperationAction, pollingState);
      end

      if (AsyncOperationStatus.is_failed_status(polling_state.status))
        fail CloudError # TODO: proper error
      end

      polling_state.azure_operation_response
    end

    def update_state_from_azure_async_operation_header(polling_state)
      response = self.get_async(polling_state.azure_async_operation_header_link)

      # TODO: verify these two setters.
      # polling_state.status = response.body.status
      # polling_state.error = response.body.error

      polling_state.response = response.response
      polling_state.request = response.request
      polling_state.resource = nil
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
        result
      end

      result = promise.execute().value!
      result
    end
  end

end
