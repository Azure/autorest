# encoding: utf-8

$: << 'RspecTests/Generated/head_exceptions'

require 'rspec'
require 'generated/head_exceptions'

include HeadExceptionsModule

describe 'HeadException' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestHeadExceptionTestService.new(@credentials, @base_url)
  end

  it 'send head exception 200' do    
    result = @client.head_exception.head200_async().value!
  end
  
  it 'send head exception 204' do
    result = @client.head_exception.head204_async().value!
  end

  it 'send head exception 404' do
    expect { @client.head_exception.head404_async().value! }.to raise_error(MsRestAzure::AzureOperationError)
  end
end