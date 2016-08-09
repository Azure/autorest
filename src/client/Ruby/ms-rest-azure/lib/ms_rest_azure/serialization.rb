# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRestAzure
  # Base module for Azure Ruby serialization and deserialization.
  #
  # Provides methods to serialize Ruby object into Ruby Hash and
  # to deserialize Ruby Hash into Ruby object.
  module Serialization
    include MsRest::Serialization

    private

    #
    # Builds serializer
    #
    def build_serializer
      Serialization.new(self)
    end

    #
    # Class to handle serialization & deserialization.
    #
    class Serialization < MsRest::Serialization::Serialization

      #
      # Retrieves model of the model_name
      #
      # @param model_name [String] Name of the model to retrieve.
      #
      def get_model(model_name)
        begin
          Object.const_get(@context.class.to_s.split('::')[0...-1].join('::') + "::Models::#{model_name}")
        rescue NameError
          # Look into MsRestAzure namespace if model name not found in the ARM's models namespace
          Object.const_get("MsRestAzure::#{model_name}")
        end
      end

    end
  end
end
