require 'ms_rest'
include MsRest

describe HttpOperationResponse do
  let(:request) { Net::HTTP::Get.new('http://localhost:8080/') }
  let(:response) { Net::HTTP::HTTPResponse.new('1.1', '200', 'OK') }
  let(:body) { 'OK' }

  it 'should create response type' do
    expect{HttpOperationResponse.new(:request, :response)}.not_to raise_error
  end

  it 'should create response type with body' do
    expect{HttpOperationResponse.new(:request, :response, :body)}.not_to raise_error
  end
end