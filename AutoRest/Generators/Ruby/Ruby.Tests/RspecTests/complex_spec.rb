# encoding: utf-8

$: << 'RspecTests/Generated/complex'

require 'base64'
require 'generated/body_complex'

module ComplexModule
  include ComplexModule::Models

describe 'Complex' do

  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestComplexTestService.new(@credentials, @base_url)
    @arrayValue = [
        "1, 2, 3, 4",
        "",
        nil,
        "&S#$(*Y",
        "The quick brown fox jumps over the lazy dog"
    ]
    @dictionary_value = {
        "txt"=> "notepad",
        "bmp"=> "mspaint",
        "xls"=> "excel",
        "exe"=> "",
        ""   => nil
    }
    @byte_wrapper = ByteWrapper.new
    @byte_wrapper.field = [0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x000, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6]
  end

  it 'should create test service' do
    expect { AutoRestComplexTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  # Array tests
  it 'should get array valid' do
    result = @client.array.get_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ArrayWrapper)
    expect(result.body.array.count).to eq(@arrayValue.count)
    expect(result.body.array.zip(@arrayValue).map {|a, e| a == e}.all?).to be_truthy
  end

  it 'should put array valid' do
    array_wrapper = ComplexModule::Models::ArrayWrapper.new
    array_wrapper.array = @arrayValue
    result = @client.array.put_valid_async(array_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get array empty' do
    result = @client.array.get_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ArrayWrapper)
    expect(result.body.array.count).to eq(0)
  end

  it 'should put array empty' do
    @arrayValue.clear
    array_wrapper = ComplexModule::Models::ArrayWrapper.new
    array_wrapper.array = @arrayValue
    result = @client.array.put_empty_async(array_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get array not provided' do
    result = @client.array.get_not_provided_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::ArrayWrapper)
    expect(result.body.array).to be_nil
  end

  # Basic operations tests
  it 'should get basic valid' do
    result = @client.basic_operations.get_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::Basic)
    expect(result.body.id).to eq(2)
    expect(result.body.name).to eq("abc")
    expect(result.body.color).to eq(ComplexModule::Models::CMYKColors::YELLOW)
  end

  it 'should put basic valid' do
    basic_request = ComplexModule::Models::Basic.new
    basic_request.id = 2
    basic_request.name = "abc"
    basic_request.color = ComplexModule::Models::CMYKColors::Magenta
    result = @client.basic_operations.put_valid_async(basic_request).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get basic invalid' do
    expect { result = @client.basic_operations.get_invalid_async().value! }.to raise_error(MsRest::DeserializationError)
  end

  it 'should get basic empty' do
    result = @client.basic_operations.get_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::Basic)
    expect(result.body.id).to be_nil
    expect(result.body.name).to be_nil
    expect(result.body.color).to be_nil
  end

  it 'should get basic null' do
    result = @client.basic_operations.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::Basic)
    expect(result.body.id).to be_nil
    expect(result.body.name).to be_nil
    expect(result.body.color).to be_nil
  end

  it 'should get basic not provided' do
    result = @client.basic_operations.get_not_provided_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  # Dictionary tests
  it 'should get dictionary valid' do
    result = @client.dictionary.get_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::DictionaryWrapper)
    expect(result.body.default_program).to eq(@dictionary_value)
  end

  it 'should put dictionary valid' do
    dict_request = ComplexModule::Models::DictionaryWrapper.new
    dict_request.default_program = @dictionary_value
    result = @client.dictionary.put_valid_async(dict_request).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get dictionary empty' do
    result = @client.dictionary.get_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::DictionaryWrapper)
    expect(result.body.default_program.count).to eq(0)
  end

  it 'should put dictionary empty' do
    dict = ComplexModule::Models::DictionaryWrapper.new
	dict.default_program = {}
    result = @client.dictionary.put_empty_async(dict).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get dictionary null' do
    result = @client.dictionary.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::DictionaryWrapper)
    expect(result.body.default_program).to be_nil
  end

  it 'should get dictionary not provided' do
    result = @client.dictionary.get_not_provided_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::DictionaryWrapper)
    expect(result.body.default_program).to be_nil
  end

  # Inheritance tests
  it 'should get inheritance valid' do
    result = @client.inheritance.get_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.id).to eq(2)
    expect(result.body.name).to eq("Siameeee")
    expect(result.body.hates[1].id).to eq(-1)
    expect(result.body.hates[1].name).to eq("Tomato")
  end

  it 'should put inheritance valid' do
    inheritance_request = ComplexModule::Models::Siamese.new

    dog1 = ComplexModule::Models::Dog.new
    dog2 = ComplexModule::Models::Dog.new
    dog1.id = 1
    dog1.name = "Potato"
    dog1.food = "tomato"
    dog2.id = -1
    dog2.name = "Tomato"
    dog2.food = "french fries"

    inheritance_request.id = 2
    inheritance_request.name = "Siameeee"
    inheritance_request.color = "green"
    inheritance_request.breed = "persian"
    inheritance_request.hates = [dog1, dog2]

    result = @client.inheritance.put_valid_async(inheritance_request).value!
    expect(result.response.status).to eq(200)
  end

  # Polymorphicrecursive tests
  it 'should get inheritance valid' do
    result = @client.polymorphicrecursive.get_valid_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.is_a?ComplexModule::Models::Salmon).to be_truthy
    expect(result.body.siblings[0].is_a?ComplexModule::Models::Shark).to be_truthy
    expect(result.body.siblings[0].siblings[0].is_a?ComplexModule::Models::Salmon).to be_truthy
    expect(result.body.siblings[0].siblings[0].location).to eq("atlantic")
  end

  it 'should put inheritance valid' do
    shark1 = ComplexModule::Models::Shark.new
    shark1.age = 6
    shark1.length = 20
    shark1.species = "predator"
    shark1.birthday = DateTime.new(2012, 1, 5, 1, 0, 0, 'Z')

    # doesn't have children.
    sawshark = ComplexModule::Models::Sawshark.new
    sawshark.age = 105
    sawshark.length = 10
    sawshark.species = "dangerous"
    sawshark.birthday = DateTime.new(1900, 1, 5, 1, 0, 0, 'Z')
    sawshark.picture = [255, 255, 255, 255, 254]

    # doesn't have children but has empty array of siblings.
    sawshark1 = ComplexModule::Models::Sawshark.new
    sawshark1.age = 105
    sawshark1.length = 10
    sawshark1.species = "dangerous"
    sawshark1.siblings = []
    sawshark1.birthday = DateTime.new(1900, 1, 5, 1, 0, 0, 'Z')
    sawshark1.picture = [255, 255, 255, 255, 254]

    # has two children: shark1 and sawshark.
    salmon = ComplexModule::Models::Salmon.new
    salmon.iswild = true
    salmon.length = 2
    salmon.location = "atlantic"
    salmon.species = "coho"
    salmon.siblings = [shark1, sawshark]

    # has two children: salmon and sawshark1
    shark = ComplexModule::Models::Shark.new
    shark.age = 6
    shark.length = 20
    shark.species = "predator"
    shark.birthday = DateTime.new(2012, 1, 5, 1, 0, 0, 'Z')
    shark.siblings = [salmon, sawshark1]

    # doesn't have children but has empty array of siblings.
    sawshark2 = ComplexModule::Models::Sawshark.new
    sawshark2.age = 105
    sawshark2.length = 10
    sawshark2.species = "dangerous"
    sawshark2.siblings = []
    sawshark2.birthday = DateTime.new(1900, 1, 5, 1, 0, 0, 'Z')
    sawshark2.picture = [255, 255, 255, 255, 254]

    # has two children: shark and sawshark2.
    recursive_request = ComplexModule::Models::Salmon.new
    recursive_request.iswild = true
    recursive_request.length = 1
    recursive_request.species = "king"
    recursive_request.location = "alaska"
    recursive_request.siblings = [shark, sawshark2]

    result = @client.polymorphicrecursive.put_valid_async(recursive_request).value!
    expect(result.response.status).to eq(200)
  end

  # Polymorphism tests
  it 'should get polymorphism valid' do
    result = @client.polymorphism.get_valid_async().value!
    expect(result.response.status).to eq(200)

    expect(result.body.location).to eq("alaska")

    expect(result.body.siblings.length).to eq(3)
    expect(result.body.siblings[0].is_a? ComplexModule::Models::Shark).to be_truthy
    expect(result.body.siblings[1].is_a? ComplexModule::Models::Sawshark).to be_truthy
    expect(result.body.siblings[2].is_a? ComplexModule::Models::Goblinshark).to be_truthy

    expect(result.body.siblings[0].age).to eq(6)
    expect(result.body.siblings[1].age).to eq(105)
    expect(result.body.siblings[2].jawsize).to eq(5)
  end

  it 'should put polymorphism valid' do
    shark = ComplexModule::Models::Shark.new
    shark.age = 6
    shark.length = 20
    shark.species = "predator"
    shark.birthday = DateTime.new(2012, 1, 5, 1, 0, 0, 'Z')

    sawshark = ComplexModule::Models::Sawshark.new
    sawshark.age = 105
    sawshark.length = 10
    sawshark.species = "dangerous"
    sawshark.birthday = DateTime.new(1900, 1, 5, 1, 0, 0, 'Z')
    sawshark.picture = [255, 255, 255, 255, 254]

    goblinshark = ComplexModule::Models::Goblinshark.new
    goblinshark.age = 1
    goblinshark.birthday = DateTime.new(2015, 8, 8, 0, 0, 0, 'Z')
    goblinshark.length = 30.0
    goblinshark.species = "scary"
    goblinshark.jawsize = 5

    polymorphism_request = ComplexModule::Models::Salmon.new
    polymorphism_request.iswild = true
    polymorphism_request.length = 1
    polymorphism_request.species = "king"
    polymorphism_request.location = "alaska"
    polymorphism_request.siblings = [shark, sawshark, goblinshark]

	result = @client.polymorphism.put_valid_async(polymorphism_request).value!
	expect(result.response.status).to eq(200)
  end

  # Primitive tests
  it 'should get int' do
    result = @client.primitive.get_int_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::IntWrapper)
    expect(result.body.field1).to eq(-1)
    expect(result.body.field2).to eq(2)
  end

  it 'should put int' do
    int_wrapper = ComplexModule::Models::IntWrapper.new
    int_wrapper.field1 = -1
    int_wrapper.field2 = 2
    result = @client.primitive.put_int_async(int_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get long' do
    result = @client.primitive.get_long_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::LongWrapper)
    expect(result.body.field1).to eq(1099511627775)
    expect(result.body.field2).to eq(-999511627788)
  end

  it 'should put long' do
    long_wrapper = ComplexModule::Models::LongWrapper.new
    long_wrapper.field1 = 1099511627775
    long_wrapper.field2 = -999511627788
    result = @client.primitive.put_long_async(long_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get float' do
    result = @client.primitive.get_float_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::FloatWrapper)
    expect(result.body.field1).to eq(1.05)
    expect(result.body.field2).to eq(-0.003)
  end

  it 'should put float' do
    float_wrapper = ComplexModule::FloatWrapper.new
    float_wrapper.field1 = 1.05
    float_wrapper.field2 = -0.003
    result = @client.primitive.put_float_async(float_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get double' do
    result = @client.primitive.get_double_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(DoubleWrapper)
    expect(result.body.field1).to eq(3e-100)
    expect(result.body.field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose).to eq(-0.000000000000000000000000000000000000000000000000000000005)
  end

  it 'should put double' do
    double_wrapper = DoubleWrapper.new
    double_wrapper.field1 = 3e-100
    double_wrapper.field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose = -0.000000000000000000000000000000000000000000000000000000005
    result = @client.primitive.put_double_async(double_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get bool' do
    result = @client.primitive.get_bool_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::BooleanWrapper)
    expect(result.body.field_true).to eq(true)
    expect(result.body.field_false).to eq(false)
  end

  it 'should put bool' do
    bool_wrapper = ComplexModule::BooleanWrapper.new
    bool_wrapper.field_true = true
    bool_wrapper.field_false = false
    result = @client.primitive.put_bool_async(bool_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get date' do
    result = @client.primitive.get_date_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::DateWrapper)
    expect(result.body.field).to eq(Date.parse('0001-01-01'))
    expect(result.body.leap).to eq(Date.parse('2016-02-29'))
  end

  it 'should put date' do
    date_wrapper = ComplexModule::DateWrapper.new
    date_wrapper.field = Date.parse('0001-01-01')
    date_wrapper.leap = Date.parse('2016-02-29')
    result = @client.primitive.put_date_async(date_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get dateTime' do
    result = @client.primitive.get_date_time_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::DatetimeWrapper)
    expect(result.body.field).to eq(DateTime.new(1, 1, 1, 0, 0, 0))
    expect(result.body.now).to eq(DateTime.new(2015, 5, 18, 18, 38, 0))
  end

  # Test fails because of Azure's issue with server's expectations
  it 'should put dateTime' do
    date_time_wrapper = ComplexModule::DatetimeWrapper.new
    date_time_wrapper.field = DateTime.new(1, 1, 1, 0, 0, 0)
    date_time_wrapper.now = DateTime.new(2015, 5, 18, 18, 38, 0)
    result = @client.primitive.put_date_time_async(date_time_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put dateTimeRfc1123' do
    pending("DateTime.new(1, 1, 1, 0, 0, 0, 'Z') is interpreted as Sat, 01 Jan 0001 00:00:00 GMT, but other languages interpret it as Mon, 01 Jan 0001...")
    date_time_rfc1123_wrapper = ComplexModule::Datetimerfc1123Wrapper.new
    date_time_rfc1123_wrapper.field = DateTime.new(1, 1, 1, 0, 0, 0, 'Z')
    date_time_rfc1123_wrapper.now = DateTime.new(2015, 5, 18, 11, 38, 0, 'Z')
    expect(date_time_rfc1123_wrapper.field.new_offset(0).strftime('%a, %d %b %Y %H:%M:%S GMT')).to eq(nil)
    result = @client.primitive.put_date_time_rfc1123_async(date_time_rfc1123_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get dateTimeRfc1123' do
    result = @client.primitive.get_date_time_rfc1123_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::Datetimerfc1123Wrapper)
    expect(result.body.field).to eq(DateTime.new(1, 1, 1, 0, 0, 0, 'Z'))
    expect(result.body.now).to eq(DateTime.new(2015, 5, 18, 11, 38, 0, 'Z'))
  end

  it 'should get byte' do
    result = @client.primitive.get_byte_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_an_instance_of(ComplexModule::Models::ByteWrapper)
    expect(result.body.field).to eq(@byte_wrapper.field)
  end

  it 'should put byte' do
    result = @client.primitive.put_byte_async(@byte_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get complex primitive string type' do
    result = @client.primitive.get_string_async().value!
    expect(result.response.status).to eq(200)

    string_wrapper = result.body
    expect(string_wrapper).to be_instance_of(StringWrapper)
    expect(string_wrapper.field).to eq('goodrequest')
    expect(string_wrapper.empty).to eq('')
  end

  it 'should put complex primitive string type' do
    string_wrapper = StringWrapper.new
    string_wrapper.field = 'goodrequest'
    string_wrapper.empty = ''

    result = @client.primitive.put_string_async(string_wrapper).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get & put complex readonly property valid' do
    result = @client.readonlyproperty.get_valid_async().value!
    expect(result.response.status).to eq(200)

    readonly_obj = result.body
    expect(readonly_obj).to be_instance_of(ReadonlyObj)
    expect(readonly_obj.id).to eq('1234')
    expect(readonly_obj.size).to eq(2)

    result = @client.readonlyproperty.put_valid_async(readonly_obj).value!
    expect(result.response.status).to eq(200)
  end
end

end
