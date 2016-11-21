# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    #
    class Order
      # @return [Integer]
      attr_accessor :id

      # @return [Integer]
      attr_accessor :pet_id

      # @return [Integer]
      attr_accessor :quantity

      # @return [DateTime]
      attr_accessor :ship_date

      # @return Order Status. Possible values include: 'placed', 'approved',
      # 'delivered'
      attr_accessor :status

      # @return [Boolean]
      attr_accessor :complete


      #
      # Mapper for Order class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'Order',
          type: {
            name: 'Composite',
            class_name: 'Order',
            model_properties: {
              id: {
                required: false,
                read_only: true,
                serialized_name: 'id',
                type: {
                  name: 'Number'
                }
              },
              pet_id: {
                required: false,
                serialized_name: 'petId',
                type: {
                  name: 'Number'
                }
              },
              quantity: {
                required: false,
                serialized_name: 'quantity',
                type: {
                  name: 'Number'
                }
              },
              ship_date: {
                required: false,
                serialized_name: 'shipDate',
                type: {
                  name: 'DateTime'
                }
              },
              status: {
                required: false,
                serialized_name: 'status',
                type: {
                  name: 'String'
                }
              },
              complete: {
                required: false,
                serialized_name: 'complete',
                type: {
                  name: 'Boolean'
                }
              }
            }
          }
        }
      end
    end
  end
end
