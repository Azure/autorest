# encoding: utf-8

$: << 'RspecTests/Generated/azure_url'

require 'rspec'
require 'securerandom'

require 'generated/subscription_id_api_version'

include AzureUrlModule

describe Group do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = MicrosoftAzureTestUrl.new(@credentials, @base_url)
	@client.subscription_id = SecureRandom.uuid
  end

  it 'should get resource group' do
    result = @client.group.get_sample_resource_group_async("testgroup101").value!
    expect(result.body.name).to eq("testgroup101")
    expect(result.body.location).to eq("West US")
  end
end