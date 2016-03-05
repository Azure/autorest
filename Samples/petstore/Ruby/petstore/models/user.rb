# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    class User
      # @return [Integer]
      attr_accessor :id

      # @return [String]
      attr_accessor :username

      # @return [String]
      attr_accessor :first_name

      # @return [String]
      attr_accessor :last_name

      # @return [String]
      attr_accessor :email

      # @return [String]
      attr_accessor :password

      # @return [String]
      attr_accessor :phone

      # @return [Integer] User Status
      attr_accessor :user_status

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

        serialized_property = object.username
        output_object['username'] = serialized_property unless serialized_property.nil?

        serialized_property = object.first_name
        output_object['firstName'] = serialized_property unless serialized_property.nil?

        serialized_property = object.last_name
        output_object['lastName'] = serialized_property unless serialized_property.nil?

        serialized_property = object.email
        output_object['email'] = serialized_property unless serialized_property.nil?

        serialized_property = object.password
        output_object['password'] = serialized_property unless serialized_property.nil?

        serialized_property = object.phone
        output_object['phone'] = serialized_property unless serialized_property.nil?

        serialized_property = object.user_status
        output_object['userStatus'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [User] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = User.new

        deserialized_property = object['id']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.id = deserialized_property

        deserialized_property = object['username']
        output_object.username = deserialized_property

        deserialized_property = object['firstName']
        output_object.first_name = deserialized_property

        deserialized_property = object['lastName']
        output_object.last_name = deserialized_property

        deserialized_property = object['email']
        output_object.email = deserialized_property

        deserialized_property = object['password']
        output_object.password = deserialized_property

        deserialized_property = object['phone']
        output_object.phone = deserialized_property

        deserialized_property = object['userStatus']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.user_status = deserialized_property

        output_object
      end
    end
  end
end
