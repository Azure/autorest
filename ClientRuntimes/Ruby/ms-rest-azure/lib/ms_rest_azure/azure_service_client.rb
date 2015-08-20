# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents a point of access to the REST API.
  #
  class AzureServiceClient < MsRest::ServiceClient

    # @return [Integer] execution interval for long running operations.
    attr_accessor :long_running_operation_retry_timeout

    # @return [String] api version of the Azure in string format.
    attr_accessor :api_version

    #
    # Retrieves the result of 'PUT' operation. Perfroms polling of required.
    # @param azure_response [MsRestAzure::AzureOperationResponse] response from Azure service.
    # @param custom_headers [Hash] custom HTTP headers to apply to HTTP requests.
    # @param custom_deserialization_block [Proc] custom logic for response deserialization.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_put_operation_result(azure_response, custom_headers, custom_deserialization_block)
      fail MsRest::ValidationError, 'Azure response cannot be nil' if azure_response.nil?

      status_code = azure_response.response.status

      if (status_code != 200 && status_code != 201 && status_code != 202)
        fail AzureOperationError, "Unexpected polling status code from long running operation #{status_code}"
      end

      polling_state = PollingState.new(azure_response, @long_running_operation_retry_timeout)
      operation_url = azure_response.request.url_prefix.to_s

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          begin
            if !polling_state.azure_async_operation_header_link.nil?
              update_state_from_azure_async_operation_header(polling_state, custom_headers)
            elsif !polling_state.location_header_link.nil?
              update_state_from_location_header_on_put(polling_state, custom_headers, custom_deserialization_block)
            else
              update_state_from_get_resource_operation(operation_url, polling_state, custom_headers, custom_deserialization_block)
            end

            if (AsyncOperationStatus.is_terminal_status(polling_state.status))
              task.shutdown
            end
          rescue Exception => e
            task.shutdown
            e
          end
        end

        polling_delay = polling_state.get_delay
        polling_delay = 0.1 if polling_delay.nil? || polling_delay == 0

        task.execution_interval = polling_delay
        task.execute
        task.wait_for_termination

        polling_error = task.value
        fail polling_error if polling_error.is_a?(Exception)
      end

      if (AsyncOperationStatus.is_successful_status(polling_state.status) && polling_state.resource.nil?)
        update_state_from_get_resource_operation(operation_url, polling_state, custom_headers, custom_deserialization_block)
      end

      if (AsyncOperationStatus.is_failed_status(polling_state.status))
        fail polling_state.get_operation_error
      end

      return polling_state.get_operation_response
    end

    #
    # Retrieves the result of 'POST' or 'DELETE' operations. Perfroms polling of required.
    # @param azure_response [MsRestAzure::AzureOperationResponse] response from Azure service.
    # @param custom_headers [Proc] custom method for polling.
    # @param custom_deserialization_block [Proc] custom logic for response deserialization.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_post_or_delete_operation_result(azure_response, custom_headers, custom_deserialization_block)
      fail MsRest::ValidationError, 'Azure response cannot be nil' if azure_response.nil?
      fail MsRest::ValidationError, 'Azure response cannot have empty response object' if azure_response.response.nil?

      status_code = azure_response.response.status

      if (status_code != 200 && status_code != 202 && status_code != 204)
        fail AzureOperationError, "Unexpected polling status code from long running operation #{status_code}"
      end

      polling_state = PollingState.new(azure_response, @long_running_operation_retry_timeout)

      if (!AsyncOperationStatus.is_terminal_status(polling_state.status))
        task = Concurrent::TimerTask.new do
          begin
            if !polling_state.azure_async_operation_header_link.nil?
              update_state_from_azure_async_operation_header(polling_state, custom_headers)
            elsif !polling_state.location_header_link.nil?
              update_state_from_location_header_on_post_or_delete(polling_state, custom_headers, custom_deserialization_block)
            else
              task.shutdown
              fail AzureOperationError, 'Location header is missing from long running operation'
            end

            if (AsyncOperationStatus.is_terminal_status(polling_state.status))
              task.shutdown
            end
          rescue Exception => e
            task.shutdown
            e
          end
        end

        polling_delay = polling_state.get_delay
        polling_delay = 0.1 if polling_delay.nil? || polling_delay == 0

        task.execution_interval = polling_delay
        task.execute
        task.wait_for_termination

        polling_error = task.value
        fail polling_error if polling_error.is_a?(Exception)
      end

      if (AsyncOperationStatus.is_failed_status(polling_state.status))
        fail polling_state.get_operation_error
      end

      return polling_state.get_operation_response
    end

    #
    # Updates polling state based on location header for PUT HTTP requests.
    # @param operation_url [String] The url retrieve data from.
    # @param polling_state [MsRestAzure::PollingState] polling state to update.
    # @param custom_headers [Hash] custom headers to apply to HTTP request.
    # @param custom_deserialization_block [Proc] custom deserialization method for parsing response.
    #
    def update_state_from_get_resource_operation(operation_url, polling_state, custom_headers, custom_deserialization_block)
      result = get_async_with_custom_deserialization(operation_url, custom_headers, custom_deserialization_block)

      fail AzureOperationError, 'The response from long running operation does not contain a body' if result.response.body.nil? || result.response.body.empty?

      if (result.body.respond_to?(:properties) && result.body.properties.respond_to?(:provisioning_state) && !result.body.properties.provisioning_state.nil?)
        polling_state.status = result.body.properties.provisioning_state
      else
        polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
      end

      error_data = CloudErrorData.new
      error_data.code = polling_state.status
      error_data.message = "Long running operation failed with status #{polling_state.status}"

      polling_state.error_data = error_data
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
      result = get_async_with_custom_deserialization(polling_state.location_header_link, custom_headers, custom_deserialization_block)

      polling_state.update_response(result.response)
      polling_state.request = result.response

      status_code = result.response.status

      if (status_code == 202)
        polling_state.status = AsyncOperationStatus::IN_PROGRESS_STATUS
      elsif (status_code == 200 || status_code == 201)
        fail AzureOperationError, 'The response from long running operation does not contain a body' if result.body.nil?

        # In 202 pattern on PUT ProvisioningState may not be present in
        # the response. In that case the assumption is the status is Succeeded.
        if (result.body.respond_to?(:properties) && result.body.properties.respond_to?(:provisioning_state) && !result.body.properties.provisioning_state.nil?)
          polling_state.status = result.body.properties.provisioning_state
        else
          polling_state.status = AsyncOperationStatus::SUCCESS_STATUS
        end

        error_data = CloudErrorData.new
        error_data.code = polling_state.status
        error_data.message = "Long running operation failed with status #{polling_state.status}"

        polling_state.error_data = error_data
        polling_state.resource = result.body
      end
    end

    #
    # Updates polling state from Azure async operation header.
    # @param polling_state [MsRestAzure::PollingState] polling state.
    # @param custom_headers [Hash] custom headers to apply to HTTP request.
    def update_state_from_azure_async_operation_header(polling_state, custom_headers)
      result = get_async_with_async_operation_deserialization(polling_state.azure_async_operation_header_link, custom_headers)

      fail AzureOperationError, 'The response from long running operation does not contain a body' if result.body.nil? || result.body.status.nil?

      polling_state.status = result.body.status
      polling_state.error_data = result.body.error
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
      result = get_async_with_custom_deserialization(polling_state.location_header_link, custom_headers, custom_deserialization_block)

      polling_state.update_response(result.response)
      polling_state.request = result.request
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
      result = get_async_common(operation_url, custom_headers)

      if (!result.body.nil? && !custom_deserialization_block.nil?)
        begin
          result.body = custom_deserialization_block.call(result.body)
        rescue Exception => e
          fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, http_response.body)
        end
      end

      result
    end

    #
    # Retrives data by given URL.
    # @param operation_url [String] the URL.
    # @param custom_headers [String] headers to apply to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_async_with_async_operation_deserialization(operation_url, custom_headers)
      result = get_async_common(operation_url, custom_headers)

      result.body = AsyncOperationStatus.deserialize_object(result.body)
      result
    end

    #
    # Retrives data by given URL.
    # @param operation_url [String] the URL.
    # @param custom_headers [String] headers to apply to the HTTP request.
    #
    # @return [MsRest::HttpOperationResponse] the response.
    def get_async_common(operation_url, custom_headers)
      fail ValidationError, 'Operation url cannot be nil' if operation_url.nil?

      url = URI(operation_url.gsub(' ', '%20'))

      fail URI::Error unless url.to_s =~ /\A#{URI::regexp}\z/

      # Create HTTP transport object
      connection = Faraday.new(:url => url) do |faraday|
        faraday.use MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02
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
      http_response = connection.get do |request|
        request.headers = request_headers
        @credentials.sign_request(request) unless @credentials.nil?
      end

      status_code = http_response.status

      if (status_code != 200 && status_code != 201 && status_code != 202 && status_code != 204)
        json_error_data = JSON.load(http_response.body)
        error_data = CloudErrorData.deserialize_object(json_error_data)

        fail AzureOperationError.new connection, http_response, error_data, "Long running operation failed with status #{status_code}"
      end

      result = MsRest::HttpOperationResponse.new(connection, http_response, http_response.body)

      begin
        result.body = JSON.load(http_response.body) unless http_response.body.to_s.empty?
      rescue Exception => e
        fail MsRest::DeserializationError.new("Error occured in deserializing the response", e.message, e.backtrace, http_response.body)
      end

      result
    end
  end

end
