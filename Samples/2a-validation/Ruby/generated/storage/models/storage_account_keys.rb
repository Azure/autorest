# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Storage
  module Models
    #
    # The access keys for the storage account.
    #
    class StorageAccountKeys

      include MsRestAzure

      include MsRest::JSONable
      # @return [String] Gets the value of key 1.
      attr_accessor :key1

      # @return [String] Gets the value of key 2.
      attr_accessor :key2


      #
      # Mapper for StorageAccountKeys class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'StorageAccountKeys',
          type: {
            name: 'Composite',
            class_name: 'StorageAccountKeys',
            model_properties: {
              key1: {
                required: false,
                serialized_name: 'key1',
                type: {
                  name: 'String'
                }
              },
              key2: {
                required: false,
                serialized_name: 'key2',
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
