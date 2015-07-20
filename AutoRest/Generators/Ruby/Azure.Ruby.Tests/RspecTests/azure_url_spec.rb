require 'rspec'
require 'securerandom'
require_relative 'AzureURL/sdk_requirements'
include MyNamespace

describe Group do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    dummySubscription = '1-1-1-1'
    @credentials = MsRestAzure::TokenCloudCredentials.new(dummySubscription, dummyToken)

    @client = MicrosoftAzureTestUrl.new(@credentials, @base_url)
	@client.subscription_id = SecureRandom.uuid
  end

  it 'should get resource group' do
    result = @client.group.get_sample_resource_group("testgroup101").value!
    expect(result.body.name).to eq("testgroup101")
    expect(result.body.location).to eq("West US")
  end
end