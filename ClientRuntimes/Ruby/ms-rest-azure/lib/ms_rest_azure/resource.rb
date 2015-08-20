# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
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

    # @return [String] the location of the resource (required).
    attr_accessor :location

    # @return [Hash{String => String}] the tags attached to resources (optional).
    attr_accessor :tags

    #
    # Serializes given resource object into hash.
    # @param object [Resource] resource object to serialize.
    #
    # @return [Hash] hash representation of resource.
    def self.serialize_object(object)
      object.validate
      output_object = {}

      serialized_property = object.id
      output_object['id'] = serialized_property unless serialized_property.nil?

      serialized_property = object.name
      output_object['name'] = serialized_property unless serialized_property.nil?

      serialized_property = object.type
      output_object['type'] = serialized_property unless serialized_property.nil?

      serialized_property = object.location
      output_object['location'] = serialized_property unless serialized_property.nil?

      serialized_property = object.tags
      output_object['tags'] = serialized_property unless serialized_property.nil?

      output_object
    end

    #
    # Deserializes given hash object into resource.
    # @param object [Hash] resource in hash representation to deserialize.
    #
    # @return [Resource] deserialized resource.
    def self.deserialize_object(object)
      return if object.nil?
      output_object = Resource.new

      deserialized_property = object['id']
      output_object.id = deserialized_property

      deserialized_property = object['name']
      output_object.name = deserialized_property

      deserialized_property = object['type']
      output_object.type = deserialized_property

      deserialized_property = object['location']
      output_object.location = deserialized_property

      deserialized_property = object['tags']
      output_object.tags = deserialized_property

      output_object.validate
      output_object
    end

    #
    # Validates the resource. Throws error if there is any property is incorrect.
    #
    def validate
      fail MsRest::ValidationError, 'Location cannot be nil in the Resource object' if @location.nil?
    end

  end
end
