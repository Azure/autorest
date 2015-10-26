# encoding: utf-8

require 'open3'
RSpec.configure do |config|
  config.register_ordering(:global) do |items|
    items.sort_by do |group|
      group.description.include?('AutoRestReportService')? 40: 20
    end
  end
end