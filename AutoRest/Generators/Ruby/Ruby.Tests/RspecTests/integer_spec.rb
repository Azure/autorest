require_relative 'Integer/sdk_requirements'
include MyNamespace

describe Int do
  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	@credentials = ClientRuntime::TokenCredentials.new(dummyToken)

    client = MyNamespace::AutoRestIntegerTestService.new(@credentials, @base_url)
    @int_client = MyNamespace::Int.new(client)
  end

  it 'should create test service' do
    expect{MyNamespace::AutoRestIntegerTestService.new(@credentials, @base_url)}.not_to raise_error
  end

  it 'should get overflow int32' do
    result = @int_client.get_overflow_int32().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq(2147483656)
  end

  it 'should get underflow int32' do
    result = @int_client.get_underflow_int32().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq(-2147483656)
  end

  it 'should get overflow int64' do
    result = @int_client.get_overflow_int64().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq(9223372036854775910)
  end

  it 'should get underflow int64' do
    result = @int_client.get_underflow_int64().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq(-9223372036854775910)
  end

  it 'should put max32' do
    result = @int_client.put_max32(2147483647).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should put min32' do
    result = @int_client.put_min32(-2147483648).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should put max64' do
    result = @int_client.put_max64(9223372036854776000).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should put min64' do
    result = @int_client.put_min64(-9223372036854776000).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get null' do
    result = @int_client.get_null().value!
	expect(result.response).to be_an_instance_of(Net::HTTPOK)
	expect(result.body).to eq(nil)
  end

  it 'should get invalid' do
    expect{ @int_client.get_invalid().value! }.to raise_error(ClientRuntime::DeserializationError)
  end
end