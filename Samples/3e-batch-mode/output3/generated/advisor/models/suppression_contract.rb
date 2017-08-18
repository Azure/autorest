# encoding: utf-8
# Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.

module Advisor
  module Models
    #
    # The details of the snoozed or dismissed rule; for example, the duration,
    # name, and GUID associated with the rule.
    #
    class SuppressionContract < Resource
      include MsRest::JSONable
      # @return [String] The GUID of the suppression.
      attr_accessor :suppression_id

      # @return [String] The duration for which the suppression is valid.
      attr_accessor :ttl


      #
      # Mapper for SuppressionContract class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'SuppressionContract',
          type: {
            name: 'Composite',
            class_name: 'SuppressionContract',
            model_properties: {
              id: {
                required: false,
                read_only: true,
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
              suppression_id: {
                required: false,
                serialized_name: 'properties.suppressionId',
                type: {
                  name: 'String'
                }
              },
              ttl: {
                required: false,
                serialized_name: 'properties.ttl',
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
end
