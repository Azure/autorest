# encoding: utf-8
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

require 'rspec'
require 'ms_rest_azure'

module MsRestAzure
  class Helper
    include MsRest::Serialization
  end

  describe SubResource do
    before (:all) do
      @helper = Helper.new
    end

    it 'should serialize SubResource correctly' do
      sub_resource = SubResource.new
      sub_resource.id = 'the_id'

      allow_any_instance_of(MsRest::Serialization::Serialization).to receive(:get_model).and_return(SubResource)
      sub_resource_serialized = @helper.serialize(SubResource.mapper(), sub_resource, 'sub_resource')

      expect(sub_resource_serialized).to be_a(Hash)
      expect(sub_resource_serialized['id']).to eq('the_id')
    end

    it 'should deserialize SubResource correctly' do
      sub_resource_hash = {
          'id' => 'the_id'
      }
      allow_any_instance_of(MsRest::Serialization::Serialization).to receive(:get_model).and_return(SubResource)
      sub_resource = @helper.deserialize(SubResource.mapper(), sub_resource_hash, 'sub_resource_hash')

      expect(sub_resource).to be_a(SubResource)
      expect(sub_resource.id).to eq('the_id')
    end
  end
end