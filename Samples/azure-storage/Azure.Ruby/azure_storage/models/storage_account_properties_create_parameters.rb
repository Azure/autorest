# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    class StorageAccountPropertiesCreateParameters

      include MsRestAzure

      # @return [AccountType] Gets or sets the account type. Possible values
      # include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
      # 'Standard_RAGRS', 'Premium_LRS'
      attr_accessor :account_type


      #
      # Mapper for StorageAccountPropertiesCreateParameters class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'StorageAccountPropertiesCreateParameters',
          type: {
            name: 'Composite',
            class_name: 'StorageAccountPropertiesCreateParameters',
            model_properties: {
              account_type: {
                required: true,
                serialized_name: 'accountType',
                type: {
                  name: 'Enum',
                  module: 'AccountType'
                }
              }
            }
          }
        }
      end
    end
  end
end
