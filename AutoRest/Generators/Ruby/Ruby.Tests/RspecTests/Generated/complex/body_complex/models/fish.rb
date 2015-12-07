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
    class Fish
      @@discriminatorMap = Hash.new
      @@discriminatorMap["Fish"] = "fish"
      @@discriminatorMap["salmon"] = "salmon"
      @@discriminatorMap["shark"] = "shark"
      @@discriminatorMap["sawshark"] = "sawshark"
      @@discriminatorMap["goblin"] = "goblinshark"
      @@discriminatorMap["cookiecuttershark"] = "cookiecuttershark"
      # @return [String]
      attr_accessor :species

      # @return [Float]
      attr_accessor :length

      # @return [Array<Fish>]
      attr_accessor :siblings

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
        fail MsRest::ValidationError, 'property length is nil' if @length.nil?
        @siblings.each{ |e| e.validate if e.respond_to?(:validate) } unless @siblings.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        unless object.fishtype.nil? or object.fishtype == "Fish"
          class_name = @@discriminatorMap[object.fishtype].capitalize
          class_instance = Models.const_get(class_name)
          output_object = class_instance.serialize_object(object)
        else
          output_object['fishtype'] = object.fishtype
        end

        serialized_property = object.length
        output_object['length'] = serialized_property unless serialized_property.nil?

        serialized_property = object.species
        output_object['species'] = serialized_property unless serialized_property.nil?

        serialized_property = object.siblings
        unless serialized_property.nil?
          serializedArray = []
          serialized_property.each do |element|
            unless element.nil?
              element = Fish.serialize_object(element)
            end
            serializedArray.push(element)
          end
          serialized_property = serializedArray
        end
        output_object['siblings'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [Fish] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = Fish.new

        unless object['fishtype'].nil? or object['fishtype'] == "Fish"
          class_name = @@discriminatorMap[object['fishtype']].capitalize
          class_instance = Models.const_get(class_name)
          output_object = class_instance.deserialize_object(object)
        else
          output_object.fishtype = object['fishtype']
        end

        deserialized_property = object['length']
        deserialized_property = Float(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.length = deserialized_property

        deserialized_property = object['species']
        output_object.species = deserialized_property

        deserialized_property = object['siblings']
        unless deserialized_property.nil?
          deserializedArray = [];
          deserialized_property.each do |element1|
            unless element1.nil?
              element1 = Fish.deserialize_object(element1)
            end
            deserializedArray.push(element1);
          end
          deserialized_property = deserializedArray;
        end
        output_object.siblings = deserialized_property

        output_object.validate

        output_object
      end

      def initialize
        @fishtype = "Fish"
      end

      attr_accessor :fishtype
    end
  end
end
