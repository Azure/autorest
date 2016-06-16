# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    class StorageAccountRegenerateKeyParameters

      include MsRestAzure

      # @return [String]
      attr_accessor :key_name


      #
      # Mapper for StorageAccountRegenerateKeyParameters class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'StorageAccountRegenerateKeyParameters',
          type: {
            name: 'Composite',
            class_name: 'StorageAccountRegenerateKeyParameters',
            model_properties: {
              key_name: {
                required: true,
                serialized_name: 'keyName',
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
