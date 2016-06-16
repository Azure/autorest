# encoding: utf-8

module Petstore
  module Models
    #
    # A pet

    # A group of properties representing a pet.
    #
    class Pet
      # @return [Integer] The id of the pet. A more detailed description of
      # the id of the pet.
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
      # Mapper for Pet class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'Pet',
          type: {
            name: 'Composite',
            class_name: 'Pet',
            model_properties: {
              id: {
                required: false,
                serialized_name: 'id',
                type: {
                  name: 'Number'
                }
              },
              category: {
                required: false,
                serialized_name: 'category',
                type: {
                  name: 'Composite',
                  class_name: 'Category'
                }
              },
              name: {
                required: true,
                serialized_name: 'name',
                type: {
                  name: 'String'
                }
              },
              photo_urls: {
                required: true,
                serialized_name: 'photoUrls',
                type: {
                  name: 'Sequence',
                  element: {
                      required: false,
                      serialized_name: 'StringElementType',
                      type: {
                        name: 'String'
                      }
                  }
                }
              },
              tags: {
                required: false,
                serialized_name: 'tags',
                type: {
                  name: 'Sequence',
                  element: {
                      required: false,
                      serialized_name: 'TagElementType',
                      type: {
                        name: 'Composite',
                        class_name: 'Tag'
                      }
                  }
                }
              },
              status: {
                required: false,
                serialized_name: 'status',
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
