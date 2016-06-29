# encoding: utf-8

$: << 'RspecTests/url'

require 'generated/url'

include UrlModule

describe Paths do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestUrlTestService.new(@credentials, @base_url)
    @paths_client = Paths.new(client)

    @array_path = ['ArrayPath1', "begin!*'();:@ &=+$,/?#[]end", nil, '']
  end

  it 'should create test service' do
    expect { AutoRestUrlTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get boolean true' do
    result = @paths_client.get_boolean_true_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get boolean false ' do
    result = @paths_client.get_boolean_false_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get int one million' do
    result = @paths_client.get_int_one_million_async().value!
    expect(result.response.status).to eq(200)
  end
  it 'should get int negitive one million' do
    result = @paths_client.get_int_negative_one_million_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get ten billion' do
    result = @paths_client.get_ten_billion_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get negative ten billion' do
    result = @paths_client.get_negative_ten_billion_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get float scientific positive' do
    result = @paths_client.float_scientific_positive_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get float scientific negative' do
    result = @paths_client.float_scientific_negative_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get double decimal positive' do
    result = @paths_client.double_decimal_positive_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get double decimal negative' do
    result = @paths_client.double_decimal_negative_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get string url encoded' do
    result = @paths_client.string_url_encoded_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get string empty' do
    result = @paths_client.string_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get string null' do
    expect { @paths_client.string_null_async(nil).value! }.to raise_error(ArgumentError)
  end

  # it 'should get byte multi byte' do
  #   result = @paths_client.byte_multi_byte_async("啊齄丂狛狜隣郎隣兀﨩".bytes).value!
  #   expect(result.response.status).to eq(200)
  #   expect(result.response.body).to eq("MultiByte")
  # end

  it 'should get byte empty' do
    result = @paths_client.byte_empty_async().value!
    expect(result.response.status).to eq(200)
  end

  it 'should get byte null' do
    expect { result = @paths_client.byte_null_async(nil).value! }.to raise_error(ArgumentError)
  end

  it 'should get date valid' do
    result = @paths_client.date_valid_async().value!
    expect(result.response.status).to eq(200)
  end

  # Appropriately disallowed together with CSharp
  it 'should get date null' do
    pending('Appropriately disallowed together with CSharp')
    expect { @paths_client.date_null_async('null').value! }.to raise_error(ArgumentError)
  end

  it 'should get dateTime valid' do
    pending('Appropriately disallowed together with CSharp')
    result = @paths_client.date_time_valid(DateTime.new(2012, 1, 1, 1, 1, 1, 'Z')).value!
    expect(result.response.status).to eq(200)
    expect(result.response.body).to eq("Valid")
  end

  # Appropriately disallowed together with CSharp
  it 'should get dateTime null' do
    pending('Appropriately disallowed together with CSharp')
    result = @paths_client.date_time_null_async('null').value!
    expect(result.response.status).to eq(200)
  end

  it 'should get array csv in path' do
    result = @paths_client.array_csv_in_path_async(@array_path).value!
    expect(result.response.status).to eq(200)
  end
end