# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    class Pet
      # @return [Integer]
      attr_accessor :id

      # @return [Category]
      attr_accessor :category

      # @return [String]
      attr_accessor :name

      # @return [Array<String>]
      attr_accessor :photo_urls

      # @return [Array<Tag>]
      attr_accessor :tags

      # @return pet status in the store. Possible values include: 'available',
      # 'pending', 'sold'
      attr_accessor :status

      #
      # Validate the object. Throws ValidationError if validation fails.
      #
      def validate
        fail MsRest::ValidationError, 'property name is nil' if @name.nil?
        fail MsRest::ValidationError, 'property photo_urls is nil' if @photo_urls.nil?
        @category.validate unless @category.nil?
        @photo_urls.each{ |e| e.validate if e.respond_to?(:validate) } unless @photo_urls.nil?
        @tags.each{ |e| e.validate if e.respond_to?(:validate) } unless @tags.nil?
      end

      #
      # Serializes given Model object into Ruby Hash.
      # @param object Model object to serialize.
      # @return [Hash] Serialized object in form of Ruby Hash.
      #
      def self.serialize_object(object)
        object.validate
        output_object = {}

        serialized_property = object.name
        output_object['name'] = serialized_property unless serialized_property.nil?

        serialized_property = object.photo_urls
        output_object['photoUrls'] = serialized_property unless serialized_property.nil?

        serialized_property = object.id
        output_object['id'] = serialized_property unless serialized_property.nil?

        serialized_property = object.category
        unless serialized_property.nil?
          serialized_property = Category.serialize_object(serialized_property)
        end
        output_object['category'] = serialized_property unless serialized_property.nil?

        serialized_property = object.tags
        unless serialized_property.nil?
          serializedArray = []
          serialized_property.each do |element1|
            unless element1.nil?
              element1 = Tag.serialize_object(element1)
            end
            serializedArray.push(element1)
          end
          serialized_property = serializedArray
        end
        output_object['tags'] = serialized_property unless serialized_property.nil?

        serialized_property = object.status
        output_object['status'] = serialized_property unless serialized_property.nil?

        output_object
      end

      #
      # Deserializes given Ruby Hash into Model object.
      # @param object [Hash] Ruby Hash object to deserialize.
      # @return [Pet] Deserialized object.
      #
      def self.deserialize_object(object)
        return if object.nil?
        output_object = Pet.new

        deserialized_property = object['name']
        output_object.name = deserialized_property

        deserialized_property = object['photoUrls']
        output_object.photo_urls = deserialized_property

        deserialized_property = object['id']
        deserialized_property = Integer(deserialized_property) unless deserialized_property.to_s.empty?
        output_object.id = deserialized_property

        deserialized_property = object['category']
        unless deserialized_property.nil?
          deserialized_property = Category.deserialize_object(deserialized_property)
        end
        output_object.category = deserialized_property

        deserialized_property = object['tags']
        unless deserialized_property.nil?
          deserialized_array = []
          deserialized_property.each do |element3|
            unless element3.nil?
              element3 = Tag.deserialize_object(element3)
            end
            deserialized_array.push(element3)
          end
          deserialized_property = deserialized_array
        end
        output_object.tags = deserialized_property

        deserialized_property = object['status']
        output_object.status = deserialized_property

        output_object
      end
    end
  end
end
