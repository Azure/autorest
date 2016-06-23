# encoding: utf-8

$: << 'RspecTests/Generated/head'

require 'rspec'
require 'generated/head'

include HeadModule

describe 'Head' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestHeadTestService.new(@credentials, @base_url)
  end

  it 'send head 200' do
    result = @client.http_success.head200_async().value!
    expect(result.body).to be(true)
  end
  
  it 'send head 204' do
    result = @client.http_success.head204_async().value!
    expect(result.body).to be(true)
  end

  it 'send head 404' do
    result = @client.http_success.head404_async().value!
    expect(result.body).to be(false)
  end
end