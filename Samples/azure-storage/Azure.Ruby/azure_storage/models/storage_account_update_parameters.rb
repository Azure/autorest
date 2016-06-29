# encoding: utf-8

module Petstore
  module Models
    #
    # The parameters to update on the account.
    #
    class StorageAccountUpdateParameters

      include MsRestAzure

      # @return [Hash{String => String}] Resource tags
      attr_accessor :tags

      # @return [StorageAccountPropertiesUpdateParameters]
      attr_accessor :properties


      #
      # Mapper for StorageAccountUpdateParameters class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'StorageAccountUpdateParameters',
          type: {
            name: 'Composite',
            class_name: 'StorageAccountUpdateParameters',
            model_properties: {
              tags: {
                required: false,
                serialized_name: 'tags',
                type: {
                  name: 'Dictionary',
                  value: {
                      required: false,
                      serialized_name: 'StringElementType',
                      type: {
                        name: 'String'
                      }
                  }
                }
              },
              properties: {
                required: false,
                serialized_name: 'properties',
                type: {
                  name: 'Composite',
                  class_name: 'StorageAccountPropertiesUpdateParameters'
                }
              }
            }
          }
        }
      end
    end
  end
end
