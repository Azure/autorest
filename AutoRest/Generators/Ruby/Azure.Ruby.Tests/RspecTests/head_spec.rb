require 'rspec'
require 'client_runtime'
require 'securerandom'
require_relative 'Head/sdk_requirements'
include MyNamespace

describe Head do
  before(:all) do
    @base_url = ENV['StubServerURI']
    @client = AutoRestHeadTestService.new(@base_url, TokenCloudCredentials.new(SecureRandom.uuid, SecureRandom.uuid))
  end
  it 'send head 204' do
    result = @client.http_success.head204().value!.response
    expect(result.body).to be(true)
  end
  it 'send head 404' do
    result = @client.http_success.head404().value!.response
    expect(result.body).to be(false)
  end
end