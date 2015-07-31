# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents a point of access to the REST API.
  #
  class AzureServiceClient < MsRest::ServiceClient

    # @return [String] api version of the Azure in string format.
    attr_accessor :api_version

    #
    # Creates and initialize new instance of the ServiceClient class.
    #
    def initialize(credentials, options)
      super(credentials, options)
    end

    #
    # Retrieves the result of 'PUT' operation. Perfroms polling of required.
    # @param azure_response [MsRestAzure::AzureOperationResponse] response from Azure service.
    # @param get_operation_block [Proc] custom method for polling.
    # @param custom_headers [Hash] custom HTTP headers to apply to HTTP requests.
    #
    # @return [Concurrent::Promise] promise to return response from Azure service.
    def get_put_operation_result(azure_response, get_operation_block, custom_headers, custom_deserialization_block)
      fail CloudError if azure_response.nil?
      fail CloudError if get_operation_block.nil?

      status_code = azure_response.response.status

      if (status_code != 200 && status_code != 201 && status_code != 202)
        fail CloudError
      end

      polling_state = PollingState.new(azure_response, 1) # TODO: add timeout

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          begin
            if !polling_state.azure_async_operation_header_link.nil?
              update_state_from_azure_async_operation_header(polling_state, custom_headers)
            elsif !polling_state.location_header_link.nil?
              update_state_from_location_header_on_put(polling_state, custom_headers, custom_deserialization_block)
            else
              update_state_from_get_resource_operation(get_operation_block, polling_state)
            end

            if (AsyncOperationStatus.is_terminal_status(polling_state.status))
              task.shutdown
            end
          rescue Exception => e
            task.shutdown
            e
          end
        end

        task.execution_interval = polling_state.get_delay_in_milliseconds()
        task.execute
        task.wait_for_termination

        polling_error = task.value
        fail polling_error if polling_error.is_a?(Exception)
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

    #
    # Retrieves the result of 'POST' or 'DELETE' operations. Perfroms polling of required.
    # @param azure_response [MsRestAzure::AzureOperationResponse] response from Azure service.
    # @param custom_headers [Proc] custom method for polling.
    # @param custom_deserialization_block [Proc] custom logic for response deserialization.
    #
    # @return [Concurrent::Promise] promise to return response from Azure service.
    def get_post_or_delete_operation_result(azure_response, custom_headers, custom_deserialization_block)
      fail CloudError if azure_response.nil?
      fail CloudError if azure_response.response.nil?

      status_code = azure_response.response.status

      if (status_code != 200 && status_code != 202 && status_code != 204)
        fail CloudError
      end

      polling_state = PollingState.new(azure_response, 1) # TODO: add timeout

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          begin
            if !polling_state.azure_async_operation_header_link.nil?
              update_state_from_azure_async_operation_header(polling_state, custom_headers)
            elsif !polling_state.location_header_link.nil?
              update_state_from_location_header_on_post_or_delete(polling_state, custom_headers, custom_deserialization_block)
            else
              task.shutdown
              fail CloudError
            end

            if (AsyncOperationStatus.is_terminal_status(polling_state.status))
              task.shutdown
            end
          rescue Exception => e
            task.shutdown
            e
          end
        end

        task.execution_interval = polling_state.get_delay_in_milliseconds()
        task.execute
        task.wait_for_termination

        polling_error = task.value
        fail polling_error if polling_error.is_a?(Exception)
      end

      promise = Concurrent::Promise.new do
        if (AsyncOperationStatus.is_failed_status(polling_state.status))
          fail CloudError # TODO: proper error
        end

        polling_state.get_operation_response
      end

      promise.execute
    end

    #
    # Updates polling state based on location header for PUT HTTP requests.
    # @param get_operation_block [Proc] custom method for polling.
    # @param polling_state [MsRestAzure::PollingState] polling state to update.
    def update_state_from_get_resource_operation(get_operation_block, polling_state)
      result = get_operation_block.call().value!

      fail CloudError if (result.body.nil?)

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

    #
    # Updates polling state based on location header for PUT HTTP requests.
    # @param polling_state [MsRestAzure::PollingState] polling state to update.
    # @param custom_headers [Hash] custom headers to apply to HTTP request.
    # @param custom_deserialization_block [Proc] custom deserialization method for parsing response.
    def update_state_from_location_header_on_put(polling_state, custom_headers, custom_deserialization_block)
      result = get_async_with_custom_deserialization(polling_state.location_header_link, custom_headers, custom_deserialization_block).value!

      polling_state.update_response(result.response)
      polling_state.request = result.response

      status_code = result.response.status

      if (status_code == 202)
        polling_state.status = AsyncOperationStatus::IN_PROGRESS_STATUS
      elsif (status_code == 200 || status_code == 201)
        fail CloudError if (result.body.nil?)
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

    #
    # Updates polling state from Azure async operation header.
    # @param polling_state [MsRestAzure::PollingState] polling state.
    # @param custom_headers [Hash] custom headers to apply to HTTP request.
    def update_state_from_azure_async_operation_header(polling_state, custom_headers)
      result = get_async_with_async_operation_deserialization(polling_state.azure_async_operation_header_link, custom_headers).value!

      # TODO elaborate error
      fail CloudError if (result.body.nil? || result.body.status.nil?)

      polling_state.status = result.body.status
      # TODO: fill the error
      # polling_state.error = nil
      polling_state.response = result.response
      polling_state.request = result.request
      polling_state.resource = nil
    end

    #
    # Updates polling state based on location header for POST and DELETE HTTP requests.
    # @param polling_state [MsRestAzure::PollingState] [description]
    # @param custom_headers [Hash] custom headers to apply to HTTP requests.
    # @param custom_deserialization_block [Proc] custom deserialization method for parsing response.
    def update_state_from_location_header_on_post_or_delete(polling_state, custom_headers, custom_deserialization_block)
      result = get_async_with_custom_deserialization(polling_state.location_header_link, custom_headers, custom_deserialization_block).value!

      polling_state.update_response(result.response)
      # TODO: adding response instead of request since Faraday doesn't provide request object.
      polling_state.request = result.response

      status_code = result.response.status

      if (status_code == 202)
        polling_state.status = AsyncOperationStatus::IN_PROGRESS_STATUS
      elsif (status_code == 200 || status_code == 201 || status_code == 204)
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        polling_state.resource = result.body
      end
    end

    #
    # Retrives data by given URL.
    # @param operation_url [String] the URL.
    # @param custom_headers [String] headers to apply to the HTTP request.
    # @param custom_deserialization_block [Proc] function to perform deserialization of the HTTP response.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_async_with_custom_deserialization(operation_url, custom_headers, custom_deserialization_block)
      promise = get_async_common(operation_url, custom_headers)

      promise = promise.then do |result|
        if (!result.body.nil? && !custom_deserialization_block.nil?)
          begin
            result.body = custom_deserialization_block.call(result.body)
          rescue Exception => e
            fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, http_response.body)
          end
        end

        result
      end

      promise.execute
    end

    #
    # Retrives data by given URL.
    # @param operation_url [String] the URL.
    # @param custom_headers [String] headers to apply to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_async_with_async_operation_deserialization(operation_url, custom_headers)
      promise = get_async_common(operation_url, custom_headers)

      promise = promise.then do |result|
        result.body = AsyncOperationStatus.deserialize_object(result.body)
        result
      end

      promise.execute
    end

    #
    # Retrives data by given URL.
    # @param operation_url [String] the URL.
    # @param custom_headers [String] headers to apply to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_async_common(operation_url, custom_headers)
      fail CloudError if operation_url.nil?

      # TODO: add url encoding.
      url = URI(operation_url)

      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/

      # Create HTTP transport object
      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
        faraday.use MsRestAzure::TokenRefreshMiddleware, credentials: @credentials
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
      end

      request_headers = Hash.new
      request_headers['x-ms-client-request-id'] = SecureRandom.uuid
      request_headers['Content-Type'] = 'application/json'

      unless custom_headers.nil?
        custom_headers.each do |key, value|
          request_headers[key] = value
        end
      end

      # Send Request
      promise = Concurrent::Promise.new do
        connection.get do |request|
          request.headers = request_headers
          @credentials.sign_request(request) unless @credentials.nil?
        end
      end

      promise = promise.then do |http_response|
        status_code = http_response.status

        if (status_code != 200 && status_code != 201 && status_code != 202 && status_code != 204)
          fail CloudError
        end

        result = MsRest::HttpOperationResponse.new(http_response, http_response, http_response.body)

        begin
          result.body = JSON.load(http_response.body) unless http_response.body.to_s.empty?
        rescue Exception => e
          fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, http_response.body)
        end

        result
      end

      promise
    end
  end

end
