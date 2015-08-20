# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest'

module MsRest

  describe Serialization do
    it 'should parse correct date' do
      parsed_date = Serialization.deserialize_date('1/1/2000')
      expect(parsed_date).to eq(Date.new(2000, 1, 1))
    end

    it 'should throw error if incorrect date is provided' do
      expect { Serialization.deserialize_date('13/1/2000') }.to raise_error(DeserializationError)
    end

    it 'should throw error if incorrect date format is provided' do
      expect { Serialization.deserialize_date('invalid_date') }.to raise_error(DeserializationError)
    end
  end

end