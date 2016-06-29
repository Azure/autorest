# encoding: utf-8

$: << 'RspecTests'
$: << 'RspecTests/Generated/boolean'

require 'generated/body_boolean'

module BooleanModule

  describe BooleanModule::Bool do
    before(:all) do
      @base_url = ENV['StubServerURI']

      dummyToken = 'dummy12321343423'
      @credentials = MsRest::TokenCredentials.new(dummyToken)

      client = BooleanModule::AutoRestBoolTestService.new(@credentials, @base_url)
      @bool_client = BooleanModule::Bool.new(client)
    end

    def to_bool(str)
      return true if str =~ (/^(true)$/i)
      return false if str =~ (/^(false)$/i)
      raise ArgumentError
    end

    it 'should create test service' do
      expect { BooleanModule::AutoRestBoolTestService.new(@credentials, @base_url) }.not_to raise_error
    end

    it 'should get true' do
      result = @bool_client.get_true_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to eq(true)
    end

    it 'should get false' do
      result = @bool_client.get_false_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to eq(false)
    end

    it 'should put true' do
      # expect('as').to eq('asb')
      result = @bool_client.put_true_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should put false' do
      result = @bool_client.put_false_async(false).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get null' do
      result = @bool_client.get_null_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to eq(nil)
    end

    it 'should get invalid' do
      expect { result = @bool_client.get_invalid_async().value! }.to raise_error(MsRest::DeserializationError)
    end
  end

end