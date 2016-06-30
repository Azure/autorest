# encoding: utf-8

$: << 'RspecTests/Generated/custom_base_uri_more'

require 'generated/custom_base_url_more_options'
require 'uri'

module CustomBaseUriMoreModule
  describe 'Custom base uri more options' do
    before(:all) do
      url = URI(ENV['StubServerURI'])
      @vault = "http://#{url.host}"
      @key_name = "key1"

      dummyToken = 'dummy12321343423'
      @credentials = MsRest::TokenCredentials.new(dummyToken)

      client = CustomBaseUriMoreModule::AutoRestParameterizedCustomHostTestClient.new(@credentials)
      client.subscription_id = 'test12'
      client.instance_variable_set("@dns_suffix", ":#{url.port.to_s}")
      @custom_base_url_client =  CustomBaseUriMoreModule::Paths.new(client)
    end

    it 'should get empty' do
      result = @custom_base_url_client.get_empty_async(@vault, '', @key_name).value!
      expect(result.response.status).to eq(200)
    end

    it 'should throw on nil vault or secret' do
      expect {
        @custom_base_url_client.get_empty_async(nil, nil, @key_name).value!
      }.to raise_error(ArgumentError)

      expect {
        @custom_base_url_client.get_empty_async(@vault, nil, @key_name).value!
      }.to raise_error(ArgumentError)
    end
  end
end
