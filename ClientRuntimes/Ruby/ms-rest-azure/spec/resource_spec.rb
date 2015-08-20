# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure

  describe Resource do
    it 'should serialize Resource correctly' do
      resource = Resource.new
      resource.id = 'id'
      resource.name = 'name'
      resource.type = 'type'
      resource.location = 'location'
      resource.tags = {
        'tag1' => 'tag1_value',
        'tag2' => 'tag2_value'
      }

      res = Resource.serialize_object(resource)

      expect(res).to be_a(Hash)
      expect(res['id']).to eq('id')
      expect(res['name']).to eq('name')
      expect(res['type']).to eq('type')
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

      res = Resource.deserialize_object(resource_hash)

      expect(res).to be_a(Resource)
      expect(res.id).to eq('id')
      expect(res.name).to eq('name')
      expect(res.type).to eq('type')
      expect(res.location).to eq('location')
      expect(res.tags).to eq({ 'tag1' => 'tag1_value', 'tag2' => 'tag2_value' })
    end

    it 'should throw error if location isn\'t provided' do
      resource_hash = {
          'id' => 'id',
          'name' => 'name',
          'type' => 'type'
      }

      expect { Resource.deserialize_object(resource_hash) }.to raise_error(MsRest::ValidationError)
    end
  end

end