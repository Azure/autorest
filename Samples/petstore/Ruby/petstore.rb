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

module Petstore
  autoload :SwaggerPetstore,                                    'petstore/swagger_petstore.rb'

  module Models
    autoload :User,                                               'petstore/models/user.rb'
    autoload :Category,                                           'petstore/models/category.rb'
    autoload :Pet,                                                'petstore/models/pet.rb'
    autoload :Tag,                                                'petstore/models/tag.rb'
    autoload :Order,                                              'petstore/models/order.rb'
  end
end
