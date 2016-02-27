# encoding: utf-8

require 'uri'
require 'cgi'
require 'date'
require 'json'
require 'base64'
require 'erb'
require 'securerandom'
require 'time'
require 'timeliness'
require 'faraday'
require 'faraday-cookie_jar'
require 'concurrent'
require 'ms_rest'
require 'ms_rest_azure'

module Petstore
  autoload :StorageAccounts,                                    'azure_storage/storage_accounts.rb'
  autoload :UsageOperations,                                    'azure_storage/usage_operations.rb'
  autoload :StorageManagementClient,                            'azure_storage/storage_management_client.rb'

  module Models
    autoload :StorageAccountCheckNameAvailabilityParameters,      'azure_storage/models/storage_account_check_name_availability_parameters.rb'
    autoload :CheckNameAvailabilityResult,                        'azure_storage/models/check_name_availability_result.rb'
    autoload :StorageAccountPropertiesCreateParameters,           'azure_storage/models/storage_account_properties_create_parameters.rb'
    autoload :Endpoints,                                          'azure_storage/models/endpoints.rb'
    autoload :CustomDomain,                                       'azure_storage/models/custom_domain.rb'
    autoload :StorageAccountProperties,                           'azure_storage/models/storage_account_properties.rb'
    autoload :StorageAccountKeys,                                 'azure_storage/models/storage_account_keys.rb'
    autoload :StorageAccountListResult,                           'azure_storage/models/storage_account_list_result.rb'
    autoload :StorageAccountPropertiesUpdateParameters,           'azure_storage/models/storage_account_properties_update_parameters.rb'
    autoload :StorageAccountRegenerateKeyParameters,              'azure_storage/models/storage_account_regenerate_key_parameters.rb'
    autoload :UsageName,                                          'azure_storage/models/usage_name.rb'
    autoload :Usage,                                              'azure_storage/models/usage.rb'
    autoload :UsageListResult,                                    'azure_storage/models/usage_list_result.rb'
    autoload :StorageAccount,                                     'azure_storage/models/storage_account.rb'
    autoload :Reason,                                             'azure_storage/models/reason.rb'
    autoload :AccountType,                                        'azure_storage/models/account_type.rb'
    autoload :ProvisioningState,                                  'azure_storage/models/provisioning_state.rb'
    autoload :AccountStatus,                                      'azure_storage/models/account_status.rb'
    autoload :UsageUnit,                                          'azure_storage/models/usage_unit.rb'
  end
end
