# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for
# license information.
#
# Code generated by Microsoft (R) AutoRest Code Generator 0.13.0.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

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

module HttpInfrastructureModule
  autoload :HttpFailure,                                        'http_infrastructure/http_failure.rb'
  autoload :HttpSuccess,                                        'http_infrastructure/http_success.rb'
  autoload :HttpRedirects,                                      'http_infrastructure/http_redirects.rb'
  autoload :HttpClientFailure,                                  'http_infrastructure/http_client_failure.rb'
  autoload :HttpServerFailure,                                  'http_infrastructure/http_server_failure.rb'
  autoload :HttpRetry,                                          'http_infrastructure/http_retry.rb'
  autoload :MultipleResponses,                                  'http_infrastructure/multiple_responses.rb'
  autoload :AutoRestHttpInfrastructureTestService,              'http_infrastructure/auto_rest_http_infrastructure_test_service.rb'

  module Models
    autoload :Error,                                              'http_infrastructure/models/error.rb'
    autoload :A,                                                  'http_infrastructure/models/a.rb'
    autoload :C,                                                  'http_infrastructure/models/c.rb'
    autoload :D,                                                  'http_infrastructure/models/d.rb'
    autoload :B,                                                  'http_infrastructure/models/b.rb'
  end
end
