require 'rspec'
require 'client_runtime'
require 'securerandom'
require_relative 'AzureURL/sdk_requirements'
include MyNamespace

describe Group do
  before(:all) do
    @base_url = ENV['StubServerURI']
    @client = MicrosoftAzureTestUrl.new(@base_url, TokenCloudCredentials.new(SecureRandom.uuid, SecureRandom.uuid))
  end
  it 'should get resource group' do
    result = @client.group.get_sample_resource_group("testgroup101").value!
    expect(result.body.name).to eq("testgroup101")
    expect(result.body.location).to eq("West US")
  end
end