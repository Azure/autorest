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
      # Mapper for Category class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'Category',
          type: {
            name: 'Composite',
            class_name: 'Category',
            model_properties: {
              id: {
                required: false,
                serialized_name: 'id',
                type: {
                  name: 'Number'
                }
              },
              name: {
                required: false,
                serialized_name: 'name',
                type: {
                  name: 'String'
                }
              }
            }
          }
        }
      end
    end
  end
end
