# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Class which represents any Azure resource.
  #
  class Resource

    # @return [String] the id of the resource.
    attr_accessor :id

    # @return [String] the name of the resource.
    attr_accessor :name

    # @return [String] the type of the resource.
    attr_accessor :type

    # @return [String] the state which denotes whether resource is ready to use or not.
    attr_accessor :provisioning_state

    # @return [String] the location of the resource (required).
    attr_accessor :location

    # @return [Hash{String => String}}] the tags attached to resources (optional)
    attr_accessor :tags
  end
end
