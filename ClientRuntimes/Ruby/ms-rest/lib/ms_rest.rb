# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'Base64'
require 'openssl'
require 'net/http'
require 'ms_rest/version'

require 'ms_rest/credentials/service_client_credentials'
require 'ms_rest/credentials/basic_authentication_credentials'
require 'ms_rest/credentials/token_credentials'

require 'ms_rest/deserialization_error.rb'
require 'ms_rest/serialization.rb'
require 'ms_rest/http_operation_response'
require 'ms_rest/http_operation_exception'
require 'ms_rest/retry_policy_middleware'
require 'ms_rest/token_refresh_middleware'
require 'ms_rest/service_client'

module MsRest; end
