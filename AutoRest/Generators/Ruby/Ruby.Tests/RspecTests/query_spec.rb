# encoding: utf-8

$: << 'RspecTests/url_query'

require 'rspec'
require 'url'

include UrlModule

describe Queries do

  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestUrlTestService.new(@credentials, @base_url)
    @queries_client = Queries.new(client)
  end

  it 'should create test service' do
    expect { AutoRestUrlTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get boolean true' do
    result = @queries_client.get_boolean_true_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get boolean false ' do
    result = @queries_client.get_boolean_false_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get int one million' do
    result = @queries_client.get_int_one_million_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get int negitive one million' do
    result = @queries_client.get_int_negative_one_million_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get ten billion' do
    result = @queries_client.get_ten_billion_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get negative ten billion' do
    result = @queries_client.get_negative_ten_billion_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get float scientific positive' do
    result = @queries_client.float_scientific_positive_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get float scientific negative' do
    result = @queries_client.float_scientific_negative_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get double decimal positive' do
    result = @queries_client.double_decimal_positive_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get double decimal negative' do
    result = @queries_client.double_decimal_negative_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get string url encoded' do
    result = @queries_client.string_url_encoded_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get string empty' do
    result = @queries_client.string_empty_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get string null' do
    result = @queries_client.string_null_async(nil).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get byte multi byte' do
    pending('proper working with unicode isnt implemented yet')
    fail
    # result = @queries_client.byte_multi_byte_async("啊齄丂狛狜隣郎隣兀﨩".bytes).value!
    # expect(result.response.status).to eq(200)
    # expect(result.response.body).to eq("MultiByte")
  end

  it 'should get byte empty' do
    pending('proper working with unicode isnt implemented yet')
    fail
    # result = @queries_client.byte_empty_async([]).value!
    # expect(result.response.status).to eq(200)
  end

  it 'should get byte null' do
    pending('proper working with unicode isnt implemented yet')
    fail
    # result = @queries_client.byte_null_async().value!
    # expect(result.response.status).to eq(200)
  end

  it 'should get date valid' do
    pending('proper working with datetime isnt implemented yet')
    fail
    # result = @queries_client.date_valid_async(Date.new(2012, 1, 1)).value!
    # expect(result.response.status).to eq(200)
  end

  it 'should get date null' do
    pending('proper working with datetime isnt implemented yet')
    fail
    # result = @queries_client.date_null_async().value!
    # expect(result.response.status).to eq(200)
  end

  it 'should get dateTime valid' do
    pending('proper working with datetime isnt implemented yet')
    fail
    # result = @queries_client.date_time_valid_async(DateTime.new(2012, 1, 1, 1, 1, 1, 'Z')).value!
    # expect(result.response.status).to eq(200)
  end

  it 'should get dateTime null' do
    result = @queries_client.date_time_null_async().value!
    expect(result.response.status).to eq(200)
  end
end