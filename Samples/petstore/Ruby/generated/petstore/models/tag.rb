# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    #
    class Tag
      # @return [Integer]
      attr_accessor :id

      # @return [String]
      attr_accessor :name


      #
      # Mapper for Tag class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'Tag',
          type: {
            name: 'Composite',
            class_name: 'Tag',
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
