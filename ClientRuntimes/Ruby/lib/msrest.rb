# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'Base64'
require 'openssl'
require 'net/http'
require 'client_runtime/version'

require 'client_runtime/credentials/service_client_credentials'
require 'client_runtime/credentials/basic_authentication_credentials'
require 'client_runtime/credentials/token_credentials'

require 'client_runtime/deserialization_error.rb'
require 'client_runtime/serialization.rb'
require 'client_runtime/http_operation_response'
require 'client_runtime/http_operation_exception'
require 'client_runtime/service_client'

module ClientRuntime; end
