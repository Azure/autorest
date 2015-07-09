# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module ClientRuntimeAzure
  #
  # Class which represents any Azure resource.
  #
  class SubResource

    # @return [String] the id of the resource.
    attr_accessor :id

    # @return [String] the state which denotes whether resource is ready to use or not.
    attr_accessor :provisioning_state

  end
end
