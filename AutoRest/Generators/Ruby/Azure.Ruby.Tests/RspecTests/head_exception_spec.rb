# encoding: utf-8

$: << 'RspecTests/Generated/head_exceptions'

require 'rspec'
require 'head_exceptions'

include HeadExceptionsModule

describe 'HeadException' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestHeadExceptionTestService.new(@credentials, @base_url)
  end

  it 'send head exception 200' do    
    result = @client.head_exception.head200().value!
  end
  
  it 'send head exception 204' do
    result = @client.head_exception.head204().value!
  end

  it 'send head exception 404' do
    expect { @client.head_exception.head404().value! }.to raise_error(MsRestAzure::AzureOperationError)
  end
end