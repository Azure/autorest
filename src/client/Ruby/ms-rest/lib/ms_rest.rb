# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'base64'
require 'openssl'
require 'faraday'
require 'timeliness'
require 'ms_rest/version'

require 'ms_rest/credentials/token_provider'
require 'ms_rest/credentials/string_token_provider'
require 'ms_rest/credentials/service_client_credentials'
require 'ms_rest/credentials/basic_authentication_credentials'
require 'ms_rest/credentials/token_credentials'

require 'ms_rest/rest_error.rb'
require 'ms_rest/deserialization_error.rb'
require 'ms_rest/validation_error.rb'
require 'ms_rest/serialization.rb'
require 'ms_rest/http_operation_response'
require 'ms_rest/http_operation_request'
require 'ms_rest/http_operation_error'
require 'ms_rest/retry_policy_middleware'
require 'ms_rest/service_client'

module MsRest end
module MsRest::Serialization end
