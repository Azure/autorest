# encoding: utf-8

$: << 'RspecTests'
$: << 'RspecTests/Generated/duration'

require 'generated/body_duration'

module DurationModule

  describe DurationModule::Duration do
    before(:all) do
      @base_url = ENV['StubServerURI']

      dummyToken = 'dummy12321343423'
      @credentials = MsRest::TokenCredentials.new(dummyToken)

      client = DurationModule::AutoRestDurationTestService.new(@credentials, @base_url)
      @duration_client = DurationModule::Duration.new(client)
    end

    it 'should create test service' do
      expect { DurationModule::AutoRestDurationTestService.new(@credentials, @base_url) }.not_to raise_error
    end

    it 'should properly handle null value for Duration' do
      result = @duration_client.get_null_async().value!
      expect(result.response.status).to eq(200)
    end

    it 'should properly handle invalid value for Duration' do
      result = @duration_client.get_invalid_async().value!
      expect(result.response.status).to eq(200)
      puts result.body.to_s
    end
  end

end