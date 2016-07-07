# encoding: utf-8

$: << 'RspecTests/Generated/datetime_rfc1123'

require 'rspec'
require 'generated/body_datetime_rfc1123'
require_relative './helper'

include DatetimeRfc1123Module

describe Datetimerfc1123 do

  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	@credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestRFC1123DateTimeTestService.new(@credentials, @base_url)
    @date_rfc1123_client = Datetimerfc1123.new(client)
  end

  it 'should create test service' do
    expect { AutoRestRFC1123DateTimeTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get null' do
    result = @date_rfc1123_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(nil)
  end

  it 'should get invalid' do
    pending('DateTime parsing of RFC1123 formats is not that robust, so the below doesnt throw an exception... is this okay?')
    #TODO: This fails even though this is a totally invalid time, it results in 2015-10-01T00:00:00+01:00
    expect(DateTime.parse('Tue, 01 Yoink FOOBAR 00:00:0A ABC')).to eq(nil) 
    expect { @date_rfc1123_client.get_invalid_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should get overflow' do
    result = @date_rfc1123_client.get_overflow_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(10000, 1, 1, 00, 00, 00, 'Z'))
  end

  it 'should get utc lowercase max date time' do
    result = @date_rfc1123_client.get_utc_lowercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, 'Z'))
  end

  it 'should get utc uppercase max date time' do
    result = @date_rfc1123_client.get_utc_uppercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, 'Z'))
  end

  it 'should get underflow' do
    expect{@date_rfc1123_client.get_underflow_async().value!}.to raise_error(MsRest::DeserializationError)
  end

  it 'should put utc max date' do
    result = @date_rfc1123_client.put_utc_max_date_time_async(DateTime.new(9999, 12, 31, 23, 59, 59)).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put utc min date' do
    result = @date_rfc1123_client.put_utc_min_date_time_async(DateTime.new(0001, 01, 01, 00, 00, 00)).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get utc min date time' do
    result = @date_rfc1123_client.get_utc_min_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(DateTime.new(0001, 01, 01, 00, 00, 00, 'Z'))
  end

end