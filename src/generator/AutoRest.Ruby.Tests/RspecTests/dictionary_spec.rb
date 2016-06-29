# encoding: utf-8

$: << 'RspecTests/Generated/dictionary'
$: << 'RspecTests'

require 'base64'
require 'generated/body_dictionary'
require 'helper'

include DictionaryModule
include DictionaryModule::Models

describe Dictionary do

  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	@credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestSwaggerBATdictionaryService.new(@credentials, @base_url)
    @dictionary_client = Dictionary.new(client)
    @dict_bool = { "0" => true, "1" => false, "2" => false, "3" => true}
    @dict_string = {"0"=> "foo1", "1"=> "foo2", "2"=> "foo3"}
    @dict_int = {"0"=> 1, "1"=> -1, "2"=> 3, "3"=> 300}
    @dict_float = {"0"=> 0, "1"=> -0.01, "2" => -1.2e20}
    @dict_date = {"0"=> Date.new(2000, 12, 01, 0), "1"=> Date.new(1980, 1, 2, 0), "2"=> Date.new(1492, 10, 12, 0)}
    @widget_0 = Widget.new
    @widget_0.string = "2"
    @widget_0.integer = 1
    @widget_1 = Widget.new
    @widget_1.string = "4"
    @widget_1.integer = 3
    @widget_2 = Widget.new
    @widget_2.string = "6"
    @widget_2.integer = 5
    @dict_complex = {"0"=> @widget_0, "1"=> @widget_1 , "2"=> @widget_2}
    @dict_dateTime = {"0"=> DateTime.new(2000, 12, 01, 0, 0, 1), "1"=> DateTime.new(1980, 1, 2, 0, 11, 35, '+1'), "2"=> DateTime.new(1492, 10, 12, 10, 15, 1, '-8')}
    @dict_byte = {"0" => [0x0FF, 0x0FF, 0x0FF, 0x0FA],"1" => [0x01, 0x02, 0x03],"2" => [0x025, 0x029, 0x043]}
    @dict_array= {"0" => ['1', '2', '3'], "1" => ['4', '5', '6'], "2" => ['7', '8', '9']}
    @dict_dict = {"0" => {'1'=> 'one', '2' => 'two', '3' => 'three'}, "1" => {'4'=> 'four', '5' => 'five', '6' => 'six'}, "2" => {'7'=> 'seven', '8' => 'eight', '9' => 'nine'}}
  end

  it 'should create test service' do
    expect { AutoRestSwaggerBATdictionaryService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get null' do
    result = @dictionary_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get empty' do
    result = @dictionary_client.get_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_empty
  end

  it 'should put empty' do
    result = @dictionary_client.put_empty_async({}).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get null value' do
    result = @dictionary_client.get_null_value_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"key1" => nil})
  end

  it 'should get null key' do
    expect{@dictionary_client.get_null_key_async().value!}.to raise_error(MsRest::DeserializationError)
  end

  it 'should get empty string key' do
    result = @dictionary_client.get_empty_string_key_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"" => "val1"})
  end

  it 'should get invalid' do
    expect { @dictionary_client.get_invalid_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  # Boolean tests
  it 'should get boolean tfft' do
    result = @dictionary_client.get_boolean_tfft_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_bool)
  end

  it 'should put boolean tfft' do
    result = @dictionary_client.put_boolean_tfft_async(@dict_bool).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get boolean invalid null' do
    result = @dictionary_client.get_boolean_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({ "0" => true, "1" => nil, "2" => false})
  end

  it 'should get boolean invalid string' do
    result = @dictionary_client.get_boolean_invalid_string_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({ "0" => true, "1" => "boolean", "2" => false})
  end

  #Integer tests
  it 'should get integer valid' do
    result = @dictionary_client.get_integer_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_int)
  end

  it 'should put integer valid' do
    result = @dictionary_client.put_integer_valid_async(@dict_int).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get int invalid null' do
    result = @dictionary_client.get_int_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0"=> 1, "1"=> nil, "2"=> 0})
  end

  it 'should get int invalid string' do
    expect { result = @dictionary_client.get_int_invalid_string_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  #Long integer tests. Ruby automtically converts int to long int, so there is no
  # special data type.
  it 'should get long valid' do
    result = @dictionary_client.get_long_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_int)
  end

  it 'should put long valid' do
    result = @dictionary_client.put_long_valid_async(@dict_int).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get long invalid null' do
    result = @dictionary_client.get_long_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0"=> 1, "1"=> nil, "2"=> 0})
  end

  it 'should get long invalid string' do
    expect { result = @dictionary_client.get_long_invalid_string_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  #Float tests
  it 'should get float valid' do
    result = @dictionary_client.get_float_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_float)
  end

  it 'should put float valid' do
    result = @dictionary_client.put_float_valid_async(@dict_float).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get float invalid null' do
    result = @dictionary_client.get_float_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0"=> 0.0, "1"=> nil, "2"=> -1.2e20})
  end

  it 'should get float invalid string' do
    expect { result = @dictionary_client.get_float_invalid_string_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  #Double tests
  it 'should get double valid' do
    result = @dictionary_client.get_double_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_float)
  end

  it 'should put double valid' do
    result = @dictionary_client.put_double_valid_async(@dict_float).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get double invalid null' do
    result = @dictionary_client.get_double_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0"=> 0.0, "1"=> nil, "2"=> -1.2e20})
  end

  it 'should get double invalid string' do
    expect { result = @dictionary_client.get_double_invalid_string_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  #String tests
  it 'should get string valid' do
    result = @dictionary_client.get_string_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_string)
  end

  it 'should put string valid' do
    result = @dictionary_client.put_string_valid_async(@dict_string).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get string invalid null' do
    result = @dictionary_client.get_string_with_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0" => "foo", "1" => nil, "2" => "foo2"})
  end

  it 'should get string invalid' do
    result = @dictionary_client.get_string_with_invalid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0" => "foo", "1" => 123, "2" => "foo2"})
  end

  #Date tests
  it 'should get date valid' do
    result = @dictionary_client.get_date_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_date)
  end

  it 'should put date valid' do
    result = @dictionary_client.put_date_valid_async(@dict_date).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get date invalid null' do
    result = @dictionary_client.get_date_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0" => Date.parse("2012-01-01"), "1" => nil, "2" => Date.parse("1776-07-04")})
  end

  it 'should get date invalid chars' do
    expect { @dictionary_client.get_date_invalid_chars_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  #DateTime tests
  it 'should get dateTime valid' do
    result = @dictionary_client.get_date_time_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_dateTime)
  end

  it 'should put dateTime valid' do
    result = @dictionary_client.put_date_time_valid_async(@dict_dateTime).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get dateTime invalid null' do
    result = @dictionary_client.get_date_time_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0" => DateTime.parse("2000-12-01t00:00:01z"), "1" => nil})
  end

  it 'should get dateTime invalid chars' do
    expect { @dictionary_client.get_date_time_invalid_chars_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  #Byte tests
  it 'should get byte valid' do
    result = @dictionary_client.get_byte_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(@dict_byte)
  end

  #test will fail because of Ruby's problems with JSON serialization/deserialization
  it 'should put byte valid' do
    result = @dictionary_client.put_byte_valid_async(@dict_byte).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get byte invalid null' do
    result = @dictionary_client.get_byte_invalid_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({"0"=> [171, 172, 173], "1" => nil})
  end

  #Complex tests
  it 'should get complex null' do
    result = @dictionary_client.get_complex_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get complex empty' do
    result = @dictionary_client.get_complex_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({})
  end

  it 'should get complex item null' do
    dict_null = {"0" => @widget_0, "1" => nil, "2" => @widget_2 }
    result = @dictionary_client.get_complex_item_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(dict_null.keys.count)
    dict_null.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to be_equal_objects(dict_null[key])
    end
  end

  it 'should get complex item empty' do
    dict_empty = { "0"=> @widget_0, "1"=> Widget.new, "2"=> @widget_2 }
    result = @dictionary_client.get_complex_item_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(dict_empty.keys.count)
    dict_empty.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to be_equal_objects(dict_empty[key])
    end
  end

  it 'should get complex valid' do
    result = @dictionary_client.get_complex_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(@dict_complex.keys.count)
    @dict_complex.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to be_equal_objects(@dict_complex[key])
    end
  end

  it 'should put complex valid' do
    result = @dictionary_client.put_complex_valid_async(@dict_complex).value!
    expect(result.response.status).to eq(200)
  end

  #Array tests
  it 'should get array null' do
    result = @dictionary_client.get_array_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get array empty' do
    result = @dictionary_client.get_array_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({})
  end

  it 'should get array item null' do
    dict_array_nil= {"0"=> ["1", "2", "3"], "1"=> nil, "2"=> ["7", "8", "9"]}
    result = @dictionary_client.get_array_item_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(dict_array_nil.keys.count)
    dict_array_nil.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to eq(dict_array_nil[key])
    end
  end

  it 'should get array item empty' do
    dict_array_empty = {"0"=> ["1", "2", "3"], "1"=> [], "2"=> ["7", "8", "9"]}
    result = @dictionary_client.get_array_item_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(dict_array_empty.keys.count)
    dict_array_empty.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to eq(dict_array_empty[key])
    end
  end

  it 'should get array valid' do
    result = @dictionary_client.get_array_valid_async().value!
    expect(result.response.status).to eq(200)
    @dict_array.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to eq(@dict_array[key])
    end
  end

  it 'should put array valid' do
    result = @dictionary_client.put_array_valid_async(@dict_array).value!
    expect(result.response.status).to eq(200)
  end

  #Dictionary tests
  it 'should get dictionary null' do
    result = @dictionary_client.get_dictionary_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get dictionary empty' do
    result = @dictionary_client.get_dictionary_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq({})
  end

  it 'should get dictionary item null' do
    dict_item_nil = {"0"=> {'1'=> 'one', '2' => 'two', '3' => 'three'}, "1"=> nil, "2"=> {'7'=> 'seven', '8' => 'eight', '9' => 'nine'}}
    result = @dictionary_client.get_dictionary_item_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(dict_item_nil.keys.count)
    dict_item_nil.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to be_equal_dict(dict_item_nil[key])
    end
  end

  it 'should get dictionary item empty' do
    dict_item_empty = {"0"=> {'1'=> 'one', '2' => 'two', '3' => 'three'}, "1"=> {}, "2"=> {'7'=> 'seven', '8' => 'eight', '9' => 'nine'}}
    result = @dictionary_client.get_dictionary_item_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(dict_item_empty.keys.count)
    dict_item_empty.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to be_equal_dict(dict_item_empty[key])
    end
  end

  it 'should get dictionary valid' do
    result = @dictionary_client.get_dictionary_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.keys.count).to eq(@dict_dict.keys.count)
    @dict_dict.keys.each do |key|
      expect(result.body.keys).to include(key)
      expect(result.body[key]).to be_equal_dict(@dict_dict[key])
    end
  end

  it 'should put dictionary valid' do
    result = @dictionary_client.put_dictionary_valid_async(@dict_dict).value!
    expect(result.response.status).to eq(200)
  end
end