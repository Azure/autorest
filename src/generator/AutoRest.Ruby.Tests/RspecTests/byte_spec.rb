# encoding: utf-8

$: << 'RspecTests/Generated/byte'

require 'generated/body_byte'

module ByteModule

  describe ByteModule::Byte do
    before(:all) do
      @base_url = ENV['StubServerURI']

      dummyToken = 'dummy12321343423'
      @credentials = MsRest::TokenCredentials.new(dummyToken)

      client = AutoRestSwaggerBATByteService.new(@credentials, @base_url)
      @byte_spec = Byte.new(client)
      @non_ascii_bytes = [0xFF, 0xFE, 0xFD, 0xFC, 0xFB, 0xFA, 0xF9, 0xF8, 0xF7, 0xF6]
    end

    it 'should create test service' do
      expect { AutoRestSwaggerBATByteService.new(@credentials, @base_url) }.not_to raise_error
    end

    it 'should put non-ASCII bytes' do
      result = @byte_spec.put_non_ascii_async(@non_ascii_bytes).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get non-ASCII bytes' do
      result = @byte_spec.get_non_ascii_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to eq(@non_ascii_bytes)
    end

    it 'should get null' do
      result = @byte_spec.get_null_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to be_nil
    end

    it 'should get empty' do
      result = @byte_spec.get_empty_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to eq('')
    end

    it 'should get invalid' do
      expect { @byte_spec.get_invalid_async().value! }.to raise_exception(MsRest::DeserializationError)
    end
  end

end