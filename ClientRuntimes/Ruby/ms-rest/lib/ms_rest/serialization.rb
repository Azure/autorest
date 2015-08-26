# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

module MsRest
  #
  # Class which keeps the auxiliary for (de)serializing JSON requests and responses from server.
  #
  class Serialization

    #
    # Deserializes given string value into Ruby Date object.
    # @param [String] string_value string value to deserialize.
    #
    # @return [Date] deserialized Date object.
    def self.deserialize_date(string_value)
      result = Timeliness.parse(string_value, :strict => true)
      fail DeserializationError.new('Error occured in deserializing the response', nil, nil, string_value) if result.nil?
      return ::Date.parse(result.to_s)
    end
  end
end
