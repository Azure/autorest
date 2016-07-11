# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  #
  # Class which represents any Azure resource.
  #
  class Resource

    # @return [String] the id of the resource.
    attr_accessor :id

    # @return [String] the name of the resource.
    attr_accessor :name

    # @return [String] the type of the resource.
    attr_accessor :type

    # @return [String] the location of the resource (required).
    attr_accessor :location

    # @return [Hash{String => String}] the tags attached to resources (optional).
    attr_accessor :tags

    # @return [String] the kind of the resource.
    # FIXME kind attribute was introduced because of SiteInstance model of azure_mgmt_web gem has kind attribute.
    attr_accessor :kind

    def self.mapper
      {
        required: false,
        serialized_name: 'Resource',
        type: {
          name: 'Composite',
          class_name: 'Resource',
          model_properties: {
              id: {
                required: false,
                serialized_name: 'id',
                type: {
                  name: 'String'
                }
              },
              name: {
                required: false,
                read_only: true,
                serialized_name: 'name',
                type: {
                  name: 'String'
                }
              },
              type: {
                required: false,
                read_only: true,
                serialized_name: 'type',
                type: {
                  name: 'String'
                }
              },
              location: {
                required: false,
                serialized_name: 'location',
                type: {
                  name: 'String'
                }
              },
              tags: {
                required: false,
                serialized_name: 'tags',
                type: {
                  name: 'Dictionary',
                  value: {
                      required: false,
                      serialized_name: 'StringElementType',
                      type: {
                        name: 'String'
                      }
                  }
                }
              },
              kind: {
                required: false,
                serialized_name: 'kind',
                type: {
                  name: 'String'
                }
              }
          }
        }
      }
    end
  end
end
