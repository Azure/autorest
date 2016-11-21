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
require 'generated/petstore/module_definition'

module Petstore
  autoload :SwaggerPetstore,                                    'generated/petstore/swagger_petstore.rb'

  module Models
    autoload :Tag,                                                'generated/petstore/models/tag.rb'
    autoload :User,                                               'generated/petstore/models/user.rb'
    autoload :Pet,                                                'generated/petstore/models/pet.rb'
    autoload :Category,                                           'generated/petstore/models/category.rb'
    autoload :Order,                                              'generated/petstore/models/order.rb'
  end
end
