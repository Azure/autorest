# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'ms_rest'

require 'ms_rest_azure/version'

require 'ms_rest_azure/resource.rb'
require 'ms_rest_azure/sub_resource.rb'
require 'ms_rest_azure/cloud_error.rb'
require 'ms_rest_azure/azure_operation_response.rb'
require 'ms_rest_azure/async_operation_status.rb'
require 'ms_rest_azure/polling_state.rb'
require 'ms_rest_azure/azure_application_credentials.rb'
require 'ms_rest_azure/azure_service_client.rb'
require 'ms_rest_azure/token_refresh_middleware'

module MsRestAzure; end
