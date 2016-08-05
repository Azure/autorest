# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'ms_rest'
require 'ms_rest_azure/active_directory_service_settings.rb'
require 'ms_rest_azure/async_operation_status.rb'
require 'ms_rest_azure/azure_environment.rb'
require 'ms_rest_azure/azure_operation_error.rb'
require 'ms_rest_azure/azure_operation_response.rb'
require 'ms_rest_azure/azure_service_client.rb'
require 'ms_rest_azure/cloud_error_data.rb'
require 'ms_rest_azure/credentials/application_token_provider.rb'
require 'ms_rest_azure/polling_state.rb'
require 'ms_rest_azure/resource.rb'
require 'ms_rest_azure/serialization.rb'
require 'ms_rest_azure/sub_resource.rb'
require 'ms_rest_azure/version'

module MsRestAzure end
module MsRestAzure::Serialization end
module MsRestAzure::AzureEnvironments end
