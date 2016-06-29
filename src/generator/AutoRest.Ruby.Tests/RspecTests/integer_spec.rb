# encoding: utf-8

$: << 'RspecTests/Generated/integer'

require 'generated/body_integer'

include IntegerModule

describe Int do
  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	@credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestIntegerTestService.new(@credentials, @base_url)
    @int_client = Int.new(client)
  end

  it 'should create test service' do
    expect { AutoRestIntegerTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get overflow int32' do
    result = @int_client.get_overflow_int32_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(2147483656)
  end

  it 'should get underflow int32' do
    result = @int_client.get_underflow_int32_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(-2147483656)
  end

  it 'should get overflow int64' do
    result = @int_client.get_overflow_int64_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(9223372036854775910)
  end

  it 'should get underflow int64' do
    result = @int_client.get_underflow_int64_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(-9223372036854775910)
  end

  it 'should put max32' do
    result = @int_client.put_max32_async(2147483647).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put min32' do
    result = @int_client.put_min32_async(-2147483648).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put max64' do
    result = @int_client.put_max64_async(9223372036854776000).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put min64' do
    result = @int_client.put_min64_async(-9223372036854776000).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get null' do
    result = @int_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(nil)
  end

  it 'should get invalid' do
    expect{ @int_client.get_invalid_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should put unix time' do
    result = @int_client.put_unix_time_date_async(DateTime.new(2016, 4, 13, 0, 0, 0, 'Z')).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(nil)
  end

  it 'should get unix time' do
    result = @int_client.get_unix_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(DateTime.new(2016, 4, 13, 0, 0, 0, 'Z'))
  end

  it 'should get null unix time' do
    result = @int_client.get_null_unix_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(nil)
  end

  it 'should get invalid unix time' do
    expect{ @int_client.get_invalid_unix_time_async().value! }.to raise_error(MsRest::DeserializationError)
  end
end