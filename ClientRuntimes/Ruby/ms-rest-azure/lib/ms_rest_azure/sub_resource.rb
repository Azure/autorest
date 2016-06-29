# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents any Azure subresource.
  #
  class SubResource

    # @return [String] the id of the subresource.
    attr_accessor :id

    def self.mapper
      {
        required: false,
        serialized_name: 'SubResource',
        type: {
          name: 'Composite',
          class_name: 'SubResource',
          model_properties: {
            id: {
              required: false,
              serialized_name: 'id',
              type: {
                name: 'String'
              }
            }
          }
        }
      }
    end
  end
end
