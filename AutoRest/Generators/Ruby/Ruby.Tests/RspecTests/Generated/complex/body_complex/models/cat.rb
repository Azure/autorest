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
    class Cat < Pet
      # @return [String]
      attr_accessor :color

      # @return [Array<Dog>]
      attr_accessor :hates

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
        @hates.each{ |e| e.validate if e.respond_to?(:validate) } unless @hates.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.id
        output_object['id'] = serialized_property unless serialized_property.nil?

        serialized_property = object.name
        output_object['name'] = serialized_property unless serialized_property.nil?

        serialized_property = object.color
        output_object['color'] = serialized_property unless serialized_property.nil?

        serialized_property = object.hates
        unless serialized_property.nil?
          serializedArray = []
          serialized_property.each do |element|
            unless element.nil?
              element = Dog.serialize_object(element)
            end
            serializedArray.push(element)
          end
          serialized_property = serializedArray
        end
        output_object['hates'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [Cat] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = Cat.new

        deserialized_property = object['id']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.id = deserialized_property

        deserialized_property = object['name']
        output_object.name = deserialized_property

        deserialized_property = object['color']
        output_object.color = deserialized_property

        deserialized_property = object['hates']
        unless deserialized_property.nil?
          deserializedArray = [];
          deserialized_property.each do |element1|
            unless element1.nil?
              element1 = Dog.deserialize_object(element1)
            end
            deserializedArray.push(element1);
          end
          deserialized_property = deserializedArray;
        end
        output_object.hates = deserialized_property

        output_object.validate

        output_object
      end
    end
  end
end
