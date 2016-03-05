# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    class Category
      # @return [Integer]
      attr_accessor :id

      # @return [String]
      attr_accessor :name

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

        serialized_property = object.id
        output_object['id'] = serialized_property unless serialized_property.nil?

        serialized_property = object.name
        output_object['name'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [Category] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = Category.new

        deserialized_property = object['id']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.id = deserialized_property

        deserialized_property = object['name']
        output_object.name = deserialized_property

        output_object
      end
    end
  end
end
