require_relative 'Url/sdk_requirements'
include MyNamespace

describe Paths do
  before(:all) do
    @base_url = ENV['StubServerURI']
    client = AutoRestUrlTestService.new(@base_url)
    @paths_client = MyNamespace::Paths.new(client)
  end

  it 'should create test service' do
    expect{AutoRestUrlTestService.new(@base_url)}.not_to raise_error
  end
  it 'should get boolean true' do
    result = @paths_client.get_boolean_true(true).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get boolean false ' do
    result = @paths_client.get_boolean_false(false).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get int one million' do
    result = @paths_client.get_int_one_million(1000000).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get int negitive one million' do
    result = @paths_client.get_int_negative_one_million(-1000000).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get ten billion' do
    result = @paths_client.get_ten_billion(10000000000).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get negative ten billion' do
    result = @paths_client.get_negative_ten_billion(-10000000000).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get float scientific positive' do
    result = @paths_client.float_scientific_positive(1.034e20).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get float scientific negative' do
    result = @paths_client.float_scientific_negative(-1.034e-20).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get double decimal positive' do
    result = @paths_client.double_decimal_positive(9999999.999).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get double decimal negative' do
    result = @paths_client.double_decimal_negative(-9999999.999).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get string url encoded' do
    result = @paths_client.string_url_encoded("begin!*'();:@ &=+$,/?#[]end".force_encoding('')).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq("UrlEncoded")
  end
  it 'should get string empty' do
    result = @paths_client.string_empty('').value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to be_nil
  end
  it 'should get string null' do
    expect{@paths_client.string_null(nil).value!}.to raise_error(ArgumentError)
  end

  it 'should get byte multi byte' do
    result = @paths_client.byte_multi_byte("啊齄丂狛狜隣郎隣兀﨩".bytes).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.response.body).to eq("MultiByte")
  end
  it 'should get byte empty' do
    result = @paths_client.byte_empty('').value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get byte null' do
    result = @paths_client.byte_null('null').value!
    expect(result.response).to be_an_instance_of(Net::HTTPBadRequest)
  end

  it 'should get date valid' do
    pending('will be unpended after server\'s dateTime handling fixed. Now it sends InternalServerError' )
    result = @paths_client.date_valid(Date.new(2012, 1, 1)).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.response.body).to eq("Valid")
  end
  it 'should get date null' do
    expect{@paths_client.date_null('null').value!}.to raise_error(ArgumentError)
  end
  it 'should get dateTime valid' do
    pending('will be unpended after server\'s dateTime handling fixed. Now it sends InternalServerError' )
    result = @paths_client.date_time_valid(DateTime.new(2012, 1, 1, 1, 1)).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.response.body).to eq("Valid")
  end
  it 'should get dateTime null' do
    result = @paths_client.date_time_null('null').value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
end