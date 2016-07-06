# encoding: utf-8

$: << 'RspecTests/Generated/date'

require 'rspec'
require 'generated/body_date'

describe DateModule::Date do

  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    client = DateModule::AutoRestDateTestService.new(@credentials, @base_url)
    @date_client = DateModule::Date.new(client)
  end

  it 'should create test service' do
    expect { DateModule::AutoRestDateTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get null' do
    result = @date_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get invalid date' do
    expect { @date_client.get_invalid_date_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should get overflow date' do
    expect { @date_client.get_overflow_date_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should get underflow date' do
    expect { @date_client.get_underflow_date_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should put max date' do
    result = @date_client.put_max_date_async(Date.parse('9999-12-31')).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get max date' do
    result = @date_client.get_max_date_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(Date.parse('9999-12-31'))
  end

  it 'should put min date' do
    result = @date_client.put_min_date_async(Date.parse('0001-01-01')).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get min date' do
    result = @date_client.get_min_date_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(Date.parse('0001-01-01'))
  end
end