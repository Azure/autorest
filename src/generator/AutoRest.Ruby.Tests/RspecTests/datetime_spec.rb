# encoding: utf-8

$: << 'RspecTests/Generated/datetime'

require 'rspec'
require 'generated/body_datetime'
require_relative './helper'

include DatetimeModule

describe Date do

  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	@credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestDateTimeTestService.new(@credentials, @base_url)
    @date_client = Datetime.new(client)
  end

  it 'should create test service' do
    expect { AutoRestDateTimeTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get null' do
    result = @date_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(nil)
  end

  it 'should get invalid' do
    expect { @date_client.get_invalid_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should get overflow' do
    result = @date_client.get_overflow_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, '-14'))
  end

  it 'should get utc lowercase max date time' do
    result = @date_client.get_utc_lowercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, 'Z'))
  end

  it 'should get utc uppercase max date time' do
    result = @date_client.get_utc_uppercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, 'Z'))
  end

  it 'should get local positive offset lowercase max date time' do
    result = @date_client.get_local_positive_offset_lowercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, '+14'))
  end

  it 'should get local positive offset uppercase max date time' do
    result = @date_client.get_local_positive_offset_uppercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, '+14'))
  end

  it 'should get local negative offset lowercase max date time' do
    result = @date_client.get_local_negative_offset_lowercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, '-14:00'))
  end

  it 'should get local negative offset uppercase max date time' do
    result = @date_client.get_local_negative_offset_uppercase_max_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_equal_datetimes(DateTime.new(9999, 12, 31, 23, 59, 59, '-14:00'))
  end

  it 'should get underflow' do
    expect{@date_client.get_underflow_async().value!}.to raise_error(MsRest::DeserializationError)
  end

  it 'should put utc max date' do
    result = @date_client.put_utc_max_date_time_async(DateTime.new(9999, 12, 31, 23, 59, 59.9999999)).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put utc min date' do
    result = @date_client.put_utc_min_date_time_async(DateTime.new(0001, 01, 01, 00, 00, 00)).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put local positive offset min date time' do
    result = @date_client.put_local_positive_offset_min_date_time_async(DateTime.new(0001, 01, 01, 00, 00, 00, '+14')).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put local negative offset min date time' do
    result = @date_client.put_local_negative_offset_min_date_time_async(DateTime.new(0001, 01, 01, 00, 00, 00, '-14')).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put local positive offset max date time' do
    result = @date_client.put_local_positive_offset_max_date_time_async(DateTime.new(9999, 12, 31, 23, 59, 59.9999999, '+14:00')).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put local negative offset max date time' do
    pending('proper working with datetime isnt implemented yet')
    result = @date_client.put_local_negative_offset_max_date_time_async(DateTime.new(9999, 12, 31, 23, 59, 59.9999999, '-14:00')).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get utc min date time' do
    result = @date_client.get_utc_min_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(DateTime.new(0001, 01, 01, 00, 00, 00, 'Z'))
  end

  it 'should get local positive offset min date time' do
    result = @date_client.get_local_positive_offset_min_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(DateTime.new(0001, 01, 01, 00, 00, 00, '+14'))
  end

  it 'should get local negative offset min date time' do
    result = @date_client.get_local_negative_offset_min_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(DateTime.new(0001, 01, 01, 00, 00, 00, '-14'))
  end

end