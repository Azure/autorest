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

    #
    # Serializes given subresource object into hash.
    # @param object [SubResource] subresource object to serialize.
    #
    # @return [Hash] hash representation of subresource.
    def self.serialize_object(object)
      object.validate
      output_object = {}

      serialized_property = object.id
      output_object['id'] = serialized_property unless serialized_property.nil?

      output_object
    end

    #
    # Deserializes given hash object into subresource.
    # @param object [Hash] subresource in hash representation to deserialize.
    #
    # @return [SubResource] deserialized subresource.
    def self.deserialize_object(object)
      return if object.nil?
      output_object = SubResource.new

      deserialized_property = object['id']
      output_object.id = deserialized_property

      output_object.validate
      output_object
    end

    #
    # Validates the subresource. Throws error if there is any property is incorrect.
    #
    def validate
    end
  end
end
