require 'ms_rest'
include MsRest

describe ServiceClient do
  let(:header_name) { 'name' }
  let(:header_value) { 'value' }
  let(:credentials) { ServiceClientCredentials.new }

  it 'should create service type' do
    expect{ServiceClient.new()}.not_to raise_error
  end

  it 'should change service header' do
    expect{ ServiceClient.new.set_header(:header_name, :header_value)}.not_to raise_error
  end

  it 'should get service headers' do
    expect(ServiceClient.new.set_header(:header_name, :header_value).headers.length).to eql(1)
  end

  it 'should delete service header' do
    expect(ServiceClient.new.set_header(:header_name, :header_value).delete_header(:header_name).headers.length).to eql(0)
  end
end