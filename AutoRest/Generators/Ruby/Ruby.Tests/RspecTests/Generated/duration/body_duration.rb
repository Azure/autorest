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

module DurationModule
  autoload :Duration,                                           'body_duration/duration.rb'
  autoload :AutoRestDurationTestService,                        'body_duration/auto_rest_duration_test_service.rb'

  module Models
    autoload :Error,                                              'body_duration/models/error.rb'
  end
end
