require 'client_runtime'
include ClientRuntime

describe HttpOperationException do
  let(:request) { Net::HTTP::Get.new('http://localhost:8080/') }
  let(:response) { Net::HTTP::HTTPResponse.new('1.1', '200', 'OK') }
  let(:body) { 'OK' }

  it 'should create exception type' do
    expect{HttpOperationException.new(:request, :response)}.not_to(raise_error)
  end

  it 'should create exception type with body' do
    expect{HttpOperationException.new(:request, :response, :body)}.not_to(raise_error)
  end
end