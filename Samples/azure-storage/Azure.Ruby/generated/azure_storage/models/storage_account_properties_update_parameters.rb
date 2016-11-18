# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    #
    class StorageAccountPropertiesUpdateParameters

      include MsRestAzure

      # @return [AccountType] Gets or sets the account type. Note that
      # StandardZRS and PremiumLRS accounts cannot be changed to other account
      # types, and other account types cannot be changed to StandardZRS or
      # PremiumLRS. Possible values include: 'Standard_LRS', 'Standard_ZRS',
      # 'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
      attr_accessor :account_type

      # @return [CustomDomain] User domain assigned to the storage account.
      # Name is the CNAME source. Only one custom domain is supported per
      # storage account at this time. To clear the existing custom domain, use
      # an empty string for the custom domain name property.
      attr_accessor :custom_domain


      #
      # Mapper for StorageAccountPropertiesUpdateParameters class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'StorageAccountPropertiesUpdateParameters',
          type: {
            name: 'Composite',
            class_name: 'StorageAccountPropertiesUpdateParameters',
            model_properties: {
              account_type: {
                required: false,
                serialized_name: 'accountType',
                type: {
                  name: 'Enum',
                  module: 'AccountType'
                }
              },
              custom_domain: {
                required: false,
                serialized_name: 'customDomain',
                type: {
                  name: 'Composite',
                  class_name: 'CustomDomain'
                }
              }
            }
          }
        }
      end
    end
  end
end
