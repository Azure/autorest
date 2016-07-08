# encoding: utf-8

$: << 'RspecTests'
$: << 'RspecTests/Generated/header_folder'


require "base64"
require 'generated/header'

module HeaderModule
  include HeaderModule::Models

  describe 'Header' do
    before(:all) do
      @base_url = ENV['StubServerURI']

      dummyToken = 'dummy12321343423'
      @credentials = MsRest::TokenCredentials.new('Bearer', dummyToken)

      @client = AutoRestSwaggerBATHeaderService.new(@credentials, @base_url)
      @header_client = @client.header
    end

    def to_bool(str)
      return true if str =~ (/^(true)$/i)
      return false if str =~ (/^(false)$/i)
      raise ArgumentError
    end

    it 'should create test service' do
      expect { AutoRestSwaggerBATHeaderService.new(@credentials, @base_url) }.not_to raise_error
    end

    it 'should post param existing key' do
      result = @header_client.param_existing_key_async('overwrite').value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response existing key' do
      result = @header_client.response_existing_key_async().value!
      expect(result.response.status).to eq(200)
      expect(result.response['user-agent']).to eq('overwrite')
    end

    it 'should not allow to post param protected key' do
      expect { result = @header_client.param_protected_key_async('text/html').value! }.to raise_error(RuntimeError)
    end

    it 'should get response protected key' do
      result = @header_client.response_protected_key_async().value!
      expect(result.response.status).to eq(200)
      expect(result.response['content-type']).to eq('text/html; charset=utf-8')
    end

    it 'should post positive param integer' do
      result = @header_client.param_integer_async("positive", 1).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post negative param integer' do
      result = @header_client.param_integer_async("negative", -2).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response negative integer' do
      result = @header_client.response_integer_async("negative").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_i).to eq(-2)
    end

    it 'should get response positive integer' do
      result = @header_client.response_integer_async("positive").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_i).to eq(1)
    end

    it 'should post positive param long' do
      result = @header_client.param_long_async("positive", 105).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post negative param long' do
      result = @header_client.param_long_async("negative", -2).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response negative long' do
      result = @header_client.response_long_async("negative").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_i).to eq(-2)
    end

    it 'should get response positive long' do
      result = @header_client.response_long_async("positive").value!
      expect(result.response.status).to eq(200)
      expect(result.response.headers['value'].to_i).to eq(105)
    end

    it 'should post positive param float' do
      result = @header_client.param_float_async("positive", 0.07).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post negative param float' do
      result = @header_client.param_float_async("negative", -3.0).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response negative float' do
      result = @header_client.response_float_async("negative").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_f).to eq(-3.0)
    end

    it 'should get response positive float' do
      result = @header_client.response_float_async("positive").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_f).to eq(0.07)
    end

    it 'should post positive param double' do
      result = @header_client.param_double_async("positive", 7e120).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post negative param double' do
      result = @header_client.param_double_async("negative", -3.0).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response negative double' do
      result = @header_client.response_double_async("negative").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_f).to eq(-3.0)
    end

    it 'should get response positive double' do
      result = @header_client.response_double_async("positive").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value'].to_f).to eq(7e120)
    end

    it 'should post positive param bool' do
      result = @header_client.param_bool_async("true", true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post negative param bool' do
      result = @header_client.param_bool_async("false", false).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response negative bool' do
      result = @header_client.response_bool_async("true").value!
      expect(result.response.status).to eq(200)
      expect(to_bool(result.response['value'])).to eq(true)
    end

    it 'should get response positive bool' do
      result = @header_client.response_bool_async("false").value!
      expect(result.response.status).to eq(200)
      expect(to_bool(result.response['value'])).to eq(false)
    end

    it 'should post valid param string' do
      result = @header_client.param_string_async("valid", "The quick brown fox jumps over the lazy dog").value!
      expect(result.response.status).to eq(200)
    end

    it 'should post null param string' do
      result = @header_client.param_string_async("null", nil).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post empty param string' do
      result = @header_client.param_string_async('empty', '').value!
      expect(result.response.status).to eq(200)
    end

    it 'should get valid response string' do
      result = @header_client.response_string_async("valid").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value']).to eq("The quick brown fox jumps over the lazy dog")
    end

    it 'should get null response string' do
      result = @header_client.response_string_async("null").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value']).to eq("null")
    end

    it 'should get empty response string' do
      result = @header_client.response_string_async("empty").value!
      expect(result.response.status).to eq(200)
      expect(result.response['value']).to eq("")
    end

    it 'should post valid param date' do
      result = @header_client.param_date_async("valid", Date.parse('2010-01-01')).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post min param date' do
      result = @header_client.param_date_async("min", Date.parse('0001-01-01')).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response valid date' do
      result = @header_client.response_date_async("valid").value!
      expect(result.response.status).to eq(200)
      expect(Date.parse(result.response['value'])).to eq(Date.parse('2010-01-01'))
    end

    it 'should get response min date' do
      result = @header_client.response_date_async("min").value!
      expect(result.response.status).to eq(200)
      expect(Date.parse(result.response.headers['value'])).to eq(Date.parse('0001-01-01'))
    end

    it 'should post valid param dateTime' do
      result = @header_client.param_datetime_async("valid", DateTime.new(2010, 1, 1, 12, 34, 56)).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post min param dateTime' do
      result = @header_client.param_datetime_async("min", DateTime.new(1, 1, 1, 0, 0, 0)).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response valid dateTime' do
      result = @header_client.response_datetime_async("valid").value!
      expect(result.response.status).to eq(200)
      expect(Date.parse(result.response.headers['value'])).to eq(Date.parse('2010-01-01T12:34:56Z'))
    end

    it 'should get response min dateTime' do
      result = @header_client.response_datetime_async("min").value!
      expect(result.response.status).to eq(200)
      expect(Date.parse(result.response.headers['value'])).to eq(Date.parse('0001-01-01T00:00:00Z'))
    end

    it 'should post valid param dateTimeRfc1123' do
      result = @header_client.param_datetime_rfc1123_async("valid", DateTime.new(2010, 1, 1, 12, 34, 56, 'Z')).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post min param dateTimeRfc1123' do
      pending('proper working with minimum value datetime isnt implemented yet')
      result = @header_client.param_datetime_rfc1123_async("min", DateTime.new(1, 1, 1, 0, 0, 0, 'Z')).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get response valid dateTimeRfc1123' do
      result = @header_client.response_datetime_rfc1123_async("valid").value!
      expect(result.response.status).to eq(200)
      expect(Date.parse(result.response['value'])).to eq(Date.parse('2010-01-01T12:34:56Z'))
    end

    it 'should get response min dateTimeRfc1123' do
      result = @header_client.response_datetime_rfc1123_async("min").value!
      expect(result.response.status).to eq(200)
      expect(Date.parse(result.response['value'])).to eq(Date.parse('0001-01-01T00:00:00Z'))
    end
    
    it 'should post valid byte' do
      pending('proper working with unicode isnt implemented yet')
      fail
      # result = @header_client.param_byte_async("valid", "??????????".bytes).value!
      # expect(result.response.status).to eq(200)
    end

    it 'should get response valid byte' do
      pending('proper working with unicode isnt implemented yet')
      fail
      # result = @header_client.response_byte_async("valid").value!
      # expect(result.response.status).to eq(200)
      # expect(Base64.strict_decode64(result.response['value']).unpack('C*')).to eq("啊齄丂狛狜隣郎隣兀﨩".bytes.pack('U*'))
    end

    it 'should post valid enum' do
      result = @header_client.param_enum_async('valid', GreyscaleColors::GREY).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get valid enum' do
      result = @header_client.response_enum_async('valid').value!
      expect(result.response.status).to eq(200)
      expect(result.response.headers['value']).to eq(GreyscaleColors::GREY)
    end

    it 'should get null enum' do
      result = @header_client.response_enum_async('null').value!
      expect(result.response.status).to eq(200)
      expect(result.response.headers['value']).to eq('')
    end
  end

end