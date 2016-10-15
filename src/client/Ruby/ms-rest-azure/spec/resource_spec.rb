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
      expect(res['kind']).to be_nil
    end

    it 'should serialize Resource correctly with kind property' do
      resource_with_kind = Resource.new
      resource_with_kind.id = 'id'
      resource_with_kind.name = 'name'
      resource_with_kind.type = 'type'
      resource_with_kind.location = 'location'
      resource_with_kind.tags = {
        'tag1' => 'tag1_value',
        'tag2' => 'tag2_value'
      }
      resource_with_kind.kind = 'kind1'

      allow_any_instance_of(MsRest::Serialization::Serialization).to receive(:get_model).and_return(Resource)
      res = @helper.serialize(Resource.mapper(), resource_with_kind, 'resource_with_kind')

      expect(res).to be_a(Hash)
      expect(res['id']).to eq('id')
      expect(res['location']).to eq('location')
      expect(res['tags']).to eq({ 'tag1' => 'tag1_value', 'tag2' => 'tag2_value' })
      expect(res['kind']).to eq('kind1')
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
      expect(res.kind).to be_nil
    end

    it 'should deserialize Resource correctly with kind property' do
      resource_hash_with_kind = {
        'id' => 'id',
        'name' => 'name',
        'type' => 'type',
        'location' => 'location',
        'tags' => {
            'tag1' => 'tag1_value',
            'tag2' => 'tag2_value'
        },
        'kind' => 'kind2'
      }

      allow_any_instance_of(MsRest::Serialization::Serialization).to receive(:get_model).and_return(Resource)
      res = @helper.deserialize(Resource.mapper(), resource_hash_with_kind, 'resource_hash_with_kind')

      expect(res).to be_a(Resource)
      expect(res.id).to eq('id')
      expect(res.name).to eq('name')
      expect(res.type).to eq('type')
      expect(res.location).to eq('location')
      expect(res.tags).to eq({ 'tag1' => 'tag1_value', 'tag2' => 'tag2_value' })
      expect(res.kind).to eq('kind2')
    end
  end
end