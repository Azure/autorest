# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module ComplexModule
  module Models
    #
    # Model object.
    #
    class Error
      # @return [Integer]
      attr_accessor :status

      # @return [String]
      attr_accessor :message

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
        # Nothing to validate
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.status
        output_object['status'] = serialized_property unless serialized_property.nil?

        serialized_property = object.message
        output_object['message'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [Error] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = Error.new

        deserialized_property = object['status']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.status = deserialized_property

        deserialized_property = object['message']
        output_object.message = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end
