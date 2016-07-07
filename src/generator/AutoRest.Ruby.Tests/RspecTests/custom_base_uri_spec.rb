# encoding: utf-8

$: << 'RspecTests/Generated/custom_base_uri'

require 'generated/custom_base_url'
require 'uri'

module CustomBaseUriModule
  describe 'Custom base uri' do
    before(:all) do
      url = URI(ENV['StubServerURI'])
      @account_name = url.host

      dummyToken = 'dummy12321343423'
      @credentials = MsRest::TokenCredentials.new(dummyToken)

      client = CustomBaseUriModule::AutoRestParameterizedHostTestClient.new(@credentials)
      client.instance_variable_set("@host", ":#{url.port.to_s}")
      @custom_base_url_client =  CustomBaseUriModule::Paths.new(client)
    end

    it 'should get empty' do
      result = @custom_base_url_client.get_empty_async(@account_name).value!
      expect(result.response.status).to eq(200)
    end

    it 'should throw on nil account name' do
      expect {
        @custom_base_url_client.get_empty_async(nil).value!
      }.to raise_error(ArgumentError)
    end
  end
end
