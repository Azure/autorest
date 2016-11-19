# encoding: utf-8

module Petstore
  module Models
    #
    # Model object.
    #
    #
    class User
      # @return [Integer]
      attr_accessor :id

      # @return [String]
      attr_accessor :username

      # @return [String]
      attr_accessor :first_name

      # @return [String]
      attr_accessor :last_name

      # @return [String]
      attr_accessor :email

      # @return [String]
      attr_accessor :password

      # @return [String]
      attr_accessor :phone

      # @return [Integer] User Status
      attr_accessor :user_status


      #
      # Mapper for User class as Ruby Hash.
      # This will be used for serialization/deserialization.
      #
      def self.mapper()
        {
          required: false,
          serialized_name: 'User',
          type: {
            name: 'Composite',
            class_name: 'User',
            model_properties: {
              id: {
                required: false,
                serialized_name: 'id',
                type: {
                  name: 'Number'
                }
              },
              username: {
                required: false,
                serialized_name: 'username',
                type: {
                  name: 'String'
                }
              },
              first_name: {
                required: false,
                serialized_name: 'firstName',
                type: {
                  name: 'String'
                }
              },
              last_name: {
                required: false,
                serialized_name: 'lastName',
                type: {
                  name: 'String'
                }
              },
              email: {
                required: false,
                serialized_name: 'email',
                type: {
                  name: 'String'
                }
              },
              password: {
                required: false,
                serialized_name: 'password',
                type: {
                  name: 'String'
                }
              },
              phone: {
                required: false,
                serialized_name: 'phone',
                type: {
                  name: 'String'
                }
              },
              user_status: {
                required: false,
                serialized_name: 'userStatus',
                type: {
                  name: 'Number'
                }
              }
            }
          }
        }
      end
    end
  end
end
