# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    #
    class StorageAccountProperties

      include MsRestAzure

      # @return [ProvisioningState] Gets the status of the storage account at
      # the time the operation was called. Possible values include: 'Creating',
      # 'ResolvingDNS', 'Succeeded'
      attr_accessor :provisioning_state

      # @return [AccountType] Gets the type of the storage account. Possible
      # values include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
      # 'Standard_RAGRS', 'Premium_LRS'
      attr_accessor :account_type

      # @return [Endpoints] Gets the URLs that are used to perform a retrieval
      # of a public blob, queue or table object.Note that StandardZRS and
      # PremiumLRS accounts only return the blob endpoint.
      attr_accessor :primary_endpoints

      # @return [String] Gets the location of the primary for the storage
      # account.
      attr_accessor :primary_location

      # @return [AccountStatus] Gets the status indicating whether the primary
      # location of the storage account is available or unavailable. Possible
      # values include: 'Available', 'Unavailable'
      attr_accessor :status_of_primary

      # @return [DateTime] Gets the timestamp of the most recent instance of a
      # failover to the secondary location. Only the most recent timestamp is
      # retained. This element is not returned if there has never been a
      # failover instance. Only available if the accountType is StandardGRS or
      # StandardRAGRS.
      attr_accessor :last_geo_failover_time

      # @return [String] Gets the location of the geo replicated secondary for
      # the storage account. Only available if the accountType is StandardGRS
      # or StandardRAGRS.
      attr_accessor :secondary_location

      # @return [AccountStatus] Gets the status indicating whether the
      # secondary location of the storage account is available or unavailable.
      # Only available if the accountType is StandardGRS or StandardRAGRS.
      # Possible values include: 'Available', 'Unavailable'
      attr_accessor :status_of_secondary

      # @return [DateTime] Gets the creation date and time of the storage
      # account in UTC.
      attr_accessor :creation_time

      # @return [CustomDomain] Gets the user assigned custom domain assigned to
      # this storage account.
      attr_accessor :custom_domain

      # @return [Endpoints] Gets the URLs that are used to perform a retrieval
      # of a public blob, queue or table object from the secondary location of
      # the storage account. Only available if the accountType is
      # StandardRAGRS.
      attr_accessor :secondary_endpoints


      #
      # Mapper for StorageAccountProperties class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'StorageAccountProperties',
          type: {
            name: 'Composite',
            class_name: 'StorageAccountProperties',
            model_properties: {
              provisioning_state: {
                required: false,
                serialized_name: 'provisioningState',
                type: {
                  name: 'Enum',
                  module: 'ProvisioningState'
                }
              },
              account_type: {
                required: false,
                serialized_name: 'accountType',
                type: {
                  name: 'Enum',
                  module: 'AccountType'
                }
              },
              primary_endpoints: {
                required: false,
                serialized_name: 'primaryEndpoints',
                type: {
                  name: 'Composite',
                  class_name: 'Endpoints'
                }
              },
              primary_location: {
                required: false,
                serialized_name: 'primaryLocation',
                type: {
                  name: 'String'
                }
              },
              status_of_primary: {
                required: false,
                serialized_name: 'statusOfPrimary',
                type: {
                  name: 'Enum',
                  module: 'AccountStatus'
                }
              },
              last_geo_failover_time: {
                required: false,
                serialized_name: 'lastGeoFailoverTime',
                type: {
                  name: 'DateTime'
                }
              },
              secondary_location: {
                required: false,
                serialized_name: 'secondaryLocation',
                type: {
                  name: 'String'
                }
              },
              status_of_secondary: {
                required: false,
                serialized_name: 'statusOfSecondary',
                type: {
                  name: 'Enum',
                  module: 'AccountStatus'
                }
              },
              creation_time: {
                required: false,
                serialized_name: 'creationTime',
                type: {
                  name: 'DateTime'
                }
              },
              custom_domain: {
                required: false,
                serialized_name: 'customDomain',
                type: {
                  name: 'Composite',
                  class_name: 'CustomDomain'
                }
              },
              secondary_endpoints: {
                required: false,
                serialized_name: 'secondaryEndpoints',
                type: {
                  name: 'Composite',
                  class_name: 'Endpoints'
                }
              }
            }
          }
        }
      end
    end
  end
end
