# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzureTest
  class Helper
    include MsRestAzure::Serialization
  end

  describe 'Resource' do
    before (:all) do
      @helper = Helper.new
    end

    it 'should serialize Resource correctly' do
      resource = MsRestAzure::Resource.new
      resource.id = 'id'
      resource.name = 'name'
      resource.type = 'type'
      resource.location = 'location'
      resource.tags = {
        'tag1' => 'tag1_value',
        'tag2' => 'tag2_value'
      }

      res = @helper.serialize(MsRestAzure::Resource.mapper(), resource, 'resource')

      expect(res).to be_a(Hash)
      expect(res['id']).to eq('id')
      expect(res['location']).to eq('location')
      expect(res['tags']).to eq({ 'tag1' => 'tag1_value', 'tag2' => 'tag2_value' })
    end

    it 'should deserialize Resource correctly' do
      resource_hash = {
        'id' => 'id',
        'name' => 'name',
        'type' => 'type',
        'location' => 'location',
        'tags' => {
            'tag1' => 'tag1_value',
            'tag2' => 'tag2_value'
        }
      }

      res = @helper.deserialize(MsRestAzure::Resource.mapper(), resource_hash, 'resource_hash')

      expect(res).to be_a(MsRestAzure::Resource)
      expect(res.id).to eq('id')
      expect(res.name).to eq('name')
      expect(res.type).to eq('type')
      expect(res.location).to eq('location')
      expect(res.tags).to eq({ 'tag1' => 'tag1_value', 'tag2' => 'tag2_value' })
    end
  end
end