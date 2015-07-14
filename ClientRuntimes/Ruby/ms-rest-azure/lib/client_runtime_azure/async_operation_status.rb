# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Defines values for AsyncOperationStatus enum.
  #
  class AsyncOperationStatus
    IN_PROGRESS_STATUS = "InProgress"
    SUCCESS_STATUS = "Succeeded"
    FAILED_STATUS = "Failed"
    CANCELED_STATUS = "Canceled"

    FAILED_STATUSES = [FAILED_STATUS, CANCELED_STATUS]
    TERMINAL_STATUSES = [FAILED_STATUS, CANCELED_STATUS, SUCCESS_STATUS]

    DEFAULT_DELAY = 30

    # @return [Integer] delay in seconds which should be used for polling for result of async operation.
    attr_accessor :retry_after

    # @return [ClientRuntimeAzure::CloudError] error information about async operation.
    attr_accessor :cloud_error

    # @return [Stirng] status of polling.
    attr_accessor :status

    #
    # Checks if given status is terminal one.
    # @param status [String] status to verify
    #
    # @return [Boolean] True if given status is terminal one, false otherwise.
    def self.is_terminal_status(status)
      TERMINAL_STATUSES.any? { |st| st == status }
    end

    #
    # Checks if given status is failed one.
    # @param status [String] status to verify
    #
    # @return [Boolean] True if given status is failed one, false otherwise.
    def self.is_failed_status(status)
      FAILED_STATUSES.any? { |st| st == status }
    end

    #
    # Checks if given status is successful one.
    # @param status [String] status to verify
    #
    # @return [Boolean] True if given status is successful one, false otherwise.
    def self.is_successful_status(status)
      return status == SUCCESS_STATUS
    end

    def self.deserialize_object(object)
      return if object.nil?
      output_object = AsyncOperationStatus.new

      deserialized_property = object['status']

      # TODO: Check that valid enum value is provided.
      output_object.status = deserialized_property

      output_object
    end
  end

end