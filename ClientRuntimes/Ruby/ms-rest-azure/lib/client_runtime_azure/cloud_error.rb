# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Class which represents an Azure error.
  #
  class CloudError

    # @return [String] the id of the resource.
    attr_accessor :code

    # @return [String] the name of the resource.
    attr_accessor :message

    # @return [String] [description] the target of error.
    attr_accessor :target

    # @return [Array<CloudError>] the details of the error.
    attr_reader :details
  end
end
