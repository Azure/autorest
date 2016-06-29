# encoding: utf-8

$: << 'RspecTests/Generated/number'

require 'generated/body_number'

include NumberModule

describe Number do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestNumberTestService.new(@credentials, @base_url)
    @number_client = Number.new(client)
  end

  it 'should create test service' do
    expect { AutoRestNumberTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get null' do
    result = @number_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(nil)
  end

  it 'should get invalid float' do
    expect { @number_client.get_invalid_float_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should get invalid double' do
    expect { @number_client.get_invalid_double_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should put big float' do
    result = @number_client.put_big_float_async(3.402823e+20).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get big float' do
    result = @number_client.get_big_float_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(3.402823e+20)
  end

  it 'should put big double' do
    result = @number_client.put_big_double_async(2.5976931e+101).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get big double' do
    result = @number_client.get_big_double_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(2.5976931e+101)
  end

  it 'should put big double positive decimal' do
    result = @number_client.put_big_double_positive_decimal_async(99999999.99).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get big double positive decimal' do
    result = @number_client.get_big_double_positive_decimal_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(99999999.99)
  end

  it 'should put big double negative decimal' do
    result = @number_client.put_big_double_negative_decimal_async(-99999999.99).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get big double negative decimal' do
    result = @number_client.get_big_double_negative_decimal_async().value!
    expect(result.response.status).to eq(200)
    expect(Float(result.response.body)).to eq(-99999999.99)
  end

  it 'should put small float' do
    result = @number_client.put_small_float_async(3.402823e-20).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get small float' do
    result = @number_client.get_small_float_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(3.402823e-20)
  end

  it 'should put small double' do
    result = @number_client.put_small_double_async(2.5976931e-101).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get small double' do
    result = @number_client.get_small_double_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(2.5976931e-101)
  end
end