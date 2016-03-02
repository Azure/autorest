# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    class Order
      # @return [Integer]
      attr_accessor :id

      # @return [Integer]
      attr_accessor :pet_id

      # @return [Integer]
      attr_accessor :quantity

      # @return [DateTime]
      attr_accessor :ship_date

      # @return Order Status. Possible values include: 'placed', 'approved',
      # 'delivered'
      attr_accessor :status

      # @return [Boolean]
      attr_accessor :complete

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
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

        serialized_property = object.pet_id
        output_object['petId'] = serialized_property unless serialized_property.nil?

        serialized_property = object.quantity
        output_object['quantity'] = serialized_property unless serialized_property.nil?

        serialized_property = object.ship_date
        serialized_property = serialized_property.new_offset(0).strftime('%FT%TZ')
        output_object['shipDate'] = serialized_property unless serialized_property.nil?

        serialized_property = object.status
        output_object['status'] = serialized_property unless serialized_property.nil?

        serialized_property = object.complete
        output_object['complete'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [Order] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = Order.new

        deserialized_property = object['id']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.id = deserialized_property

        deserialized_property = object['petId']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.pet_id = deserialized_property

        deserialized_property = object['quantity']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.quantity = deserialized_property

        deserialized_property = object['shipDate']
        deserialized_property = DateTime.parse(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.ship_date = deserialized_property

        deserialized_property = object['status']
        output_object.status = deserialized_property

        deserialized_property = object['complete']
        output_object.complete = deserialized_property

        output_object
      end
    end
  end
end
