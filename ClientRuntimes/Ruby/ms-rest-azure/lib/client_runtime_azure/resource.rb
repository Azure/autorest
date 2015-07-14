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

    def self.serialize_object(object)
      object.validate
      output_object = {}

      serialized_property = object.id
      output_object['id'] = serialized_property unless serialized_property.nil?

      serialized_property = object.name
      output_object['name'] = serialized_property unless serialized_property.nil?

      serialized_property = object.type
      output_object['type'] = serialized_property unless serialized_property.nil?

      serialized_property = object.provisioning_state
      output_object['provisioning_state'] = serialized_property unless serialized_property.nil?

      serialized_property = object.location
      output_object['location'] = serialized_property unless serialized_property.nil?

      serialized_property = object.tags
      output_object['tags'] = serialized_property unless serialized_property.nil?

      output_object
    end

    def self.deserialize_object(object)
      return if object.nil?
      output_object = FlattenedProductProperties.new

      deserialized_property = object['id']
      output_object.id = deserialized_property

      deserialized_property = object['name']
      output_object.name = deserialized_property

      deserialized_property = object['type']
      output_object.type = deserialized_property

      deserialized_property = object['provisioning_state']
      output_object.provisioning_state = deserialized_property

      deserialized_property = object['location']
      output_object.location = deserialized_property

      deserialized_property = object['tags']
      output_object.tags = deserialized_property

      output_object.validate
      output_object
    end
  end
end
