# encoding: utf-8

$: << 'RspecTests/Generated/http_infrastructure'
$: << 'RspecTests'

require 'rspec'
require 'generated/http_infrastructure.rb'
require 'helper'

module HttpInfrastructureModule
  include HttpInfrastructureModule::Models

describe 'HttpInfrastructure' do

  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestHttpInfrastructureTestService.new(@credentials, @base_url)
    @failure_client = HttpClientFailure.new(client)
    @redirect_client = HttpRedirects.new(client)
    @retry_client = HttpRetry.new(client)
    @server_fail_client = HttpServerFailure.new(client)
    @success_client = HttpSuccess.new(client)
    @multiple_resp_client = MultipleResponses.new(client)
  end

  it 'should create test service' do
    expect { AutoRestHttpInfrastructureTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  context HttpClientFailure do
    it 'should send head 400' do
      expect { @failure_client.head400_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 400' do
      expect { @failure_client.get400_async().value! }.to raise_exception_with_code(400)
    end

    it 'should put 400' do
      expect { @failure_client.put400_async(true).value! }.to raise_exception_with_code(400)
    end

    it 'should patch 400' do
      expect { @failure_client.patch400_async(true).value! }.to raise_exception_with_code(400)
    end

    it 'should post 400' do
      expect { @failure_client.post400_async(true).value! }.to raise_exception_with_code(400)
    end

    it 'should delete 400' do
      expect { @failure_client.delete400_async(true).value! }.to raise_exception_with_code(400)
    end

    it 'should send head 401' do
      expect { @failure_client.head401_async().value! }.to raise_exception_with_code(401)
    end

    it 'should get 402' do
      expect { @failure_client.get402_async().value! }.to raise_exception_with_code(402)
    end

    it 'should get 403' do
      expect { @failure_client.get403_async().value! }.to raise_exception_with_code(403)
    end

    it 'should put 404' do
      expect { @failure_client.put404_async(true).value! }.to raise_exception_with_code(404)
    end

    it 'should patch 405' do
      expect { @failure_client.patch405_async(true).value! }.to raise_exception_with_code(405)
    end

    it 'should post 406' do
      expect { @failure_client.post406_async(true).value! }.to raise_exception_with_code(406)
    end

    it 'should delete 407' do
      expect { @failure_client.delete407_async(true).value! }.to raise_exception_with_code(407)
    end

    it 'should put 409' do
      expect { @failure_client.put409_async(true).value! }.to raise_exception_with_code(409)
    end

    it 'should send head 410' do
      expect { @failure_client.head410_async().value! }.to raise_exception_with_code(410)
    end

    it 'should get 411' do
      expect { @failure_client.get411_async().value! }.to raise_exception_with_code(411)
    end

    it 'should get 412' do
      expect { @failure_client.get412_async().value! }.to raise_exception_with_code(412)
    end

    it 'should put 413' do
      expect { @failure_client.put413_async(true).value! }.to raise_exception_with_code(413)
    end

    it 'should patch 414' do
      expect { @failure_client.patch414_async(true).value! }.to raise_exception_with_code(414)
    end

    it 'should post 415' do
      expect { @failure_client.post415_async(true).value! }.to raise_exception_with_code(415)
    end

    it 'should get 416' do
      expect { @failure_client.get416_async().value! }.to raise_exception_with_code(416)
    end

    it 'should delete 417' do
      expect { @failure_client.delete417_async(true).value! }.to raise_exception_with_code(417)
    end

    it 'should send head 429' do
      expect { @failure_client.head429_async().value! }.to raise_exception_with_code(429)
    end
  end

  context HttpRedirects do
    it 'should send head 300' do
      result = @redirect_client.head300_async().value!
      expect(result.response.status).to eq(300)
    end

    it 'should get 300' do
      result = @redirect_client.get300_async().value!
      expect(result.response.status).to eq(300)
      expect(result.body[0]).to eq("/http/success/get/200")
    end

    it 'should send head 301' do
      result = @redirect_client.head301_async().value!
      expect(result.response.status).to eq(301)
    end

    it 'should get 301' do
      result = @redirect_client.get301_async().value!
      expect(result.response.status).to eq(301)
    end

    it 'should put 301' do
      result = @redirect_client.put301_async(true).value!
      expect(result.response.status).to eq(301)
    end

    it 'should send head 302' do
      result = @redirect_client.head302_async().value!
      expect(result.response.status).to eq(302)
    end

    it 'should get 302' do
      result = @redirect_client.get302_async().value!
      expect(result.response.status).to eq(302)
    end

    it 'should patch 302' do
      result = @redirect_client.patch302_async(true).value!
      expect(result.response.status).to eq(302)
    end

    it 'should post 303' do
      result = @redirect_client.post303_async(true).value!
      expect(result.response.status).to eq(303)
    end

    it 'should send head 307' do
      result = @redirect_client.head307_async().value!
      expect(result.response.status).to eq(307)
    end

    it 'should get 307' do
      result = @redirect_client.get307_async().value!
      expect(result.response.status).to eq(307)
    end

    it 'should put 307' do
      result = @redirect_client.put307_async(true).value!
      expect(result.response.status).to eq(307)
    end

    it 'should patch 307' do
      result = @redirect_client.patch307_async(true).value!
      expect(result.response.status).to eq(307)
    end

    it 'should post 307' do
      result = @redirect_client.post307_async(true).value!
      expect(result.response.status).to eq(307)
    end

    it 'should delete 307' do
      result = @redirect_client.delete307_async(true).value!
      expect(result.response.status).to eq(307)
    end
  end

  context HttpRetry do
    it 'should send head 408' do
      result = @retry_client.head408_async().value!
      expect(result.response.status).to eq(200)
    end

    it 'should put 500' do
      result = @retry_client.put500_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should patch 500' do
      result = @retry_client.patch500_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should get 502' do
      result = @retry_client.get502_async().value!
      expect(result.response.status).to eq(200)
    end

    it 'should post 503' do
      result = @retry_client.post503_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should delete 503' do
      result = @retry_client.delete503_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should put 504' do
      result = @retry_client.put504_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should patch 504' do
      result = @retry_client.patch504_async(true).value!
      expect(result.response.status).to eq(200)
    end
  end

  context HttpServerFailure do
    it 'should send head 501' do
      expect { @server_fail_client.head501_async().value! }.to raise_exception_with_code(501)
    end

    it 'should send get 501' do
      expect { @server_fail_client.get501_async().value! }.to raise_exception_with_code(501)
    end

    it 'should send post 505' do
      expect { @server_fail_client.post505_async(true).value! }.to raise_exception_with_code(505)
    end

    it 'should send delete 505' do
      expect { @server_fail_client.delete505_async(true).value! }.to raise_exception_with_code(505)
    end
  end

  context HttpSuccess do
    it 'should send head 200' do
      result = @success_client.head200_async().value!
      expect(result.response.status).to eq(200)
    end

    it 'should get 200' do
      result = @success_client.get200_async().value!
      expect(result.body).to be_truthy
      expect(result.response.status).to eq(200)
    end

    it 'should put 200' do
      result = @success_client.put200_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should patch 200' do
      result = @success_client.patch200_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should post 200' do
      result = @success_client.post200_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should delete 200' do
      result = @success_client.delete200_async(true).value!
      expect(result.response.status).to eq(200)
    end

    it 'should put 201' do
      result = @success_client.put201_async(true).value!
      expect(result.response.status).to eq(201)
    end

    it 'should post 201' do
      result = @success_client.post201_async(true).value!
      expect(result.response.status).to eq(201)
    end

    it 'should put 202' do
      result = @success_client.put202_async(true).value!
      expect(result.response.status).to eq(202)
    end

    it 'should patch 202' do
      result = @success_client.patch202_async(true).value!
      expect(result.response.status).to eq(202)
    end

    it 'should post 202' do
      result = @success_client.post202_async(true).value!
      expect(result.response.status).to eq(202)
    end

    it 'should delete 202' do
      result = @success_client.delete202_async(true).value!
      expect(result.response.status).to eq(202)
    end

    it 'should send head 204' do
      result = @success_client.head204_async().value!
      expect(result.response.status).to eq(204)
    end

    it 'should put 204' do
      result = @success_client.put204_async(true).value!
      expect(result.response.status).to eq(204)
    end

    it 'should patch 204' do
      result = @success_client.patch204_async(true).value!
      expect(result.response.status).to eq(204)
    end

    it 'should post 204' do
      result = @success_client.post204_async(true).value!
      expect(result.response.status).to eq(204)
    end

    it 'should delete 204' do
      result = @success_client.delete204_async(true).value!
      expect(result.response.status).to eq(204)
    end
  end

  context MultipleResponses do
    it 'should get 200->204->200 valid' do
      result = @multiple_resp_client.get200model204no_model_default_error200valid_async().value!.response
      expect(result.status).to eq(200)
    end

    it 'should get 200->204->204 valid' do
      result = @multiple_resp_client.get200model204no_model_default_error204valid_async().value!.response
      expect(result.status).to eq(204)
    end

    it 'should get 200->204->201 invalid' do
      expect { @multiple_resp_client.get200model204no_model_default_error201invalid_async().value! }.to raise_exception_with_code(201)
    end

    it 'should get 200->204->202 none' do
      expect { @multiple_resp_client.get200model204no_model_default_error202none_async().value! }.to raise_exception_with_code(202)
    end

    it 'should get 200->204->400 valid' do
      expect { @multiple_resp_client.get200model204no_model_default_error400valid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 200->201->200 valid' do
      result = @multiple_resp_client.get200model201model_default_error200valid_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to be_an_instance_of(Models::A)
      expect(result.body.status_code.to_i).to eq(200)
    end

    it 'should get 200->201->201 valid' do
      result = @multiple_resp_client.get200model201model_default_error201valid_async().value!
      expect(result.response.status).to eq(201)
      expect(result.body).to be_an_instance_of(Models::B)
      expect(result.body.text_status_code).to eq("Created")
    end

    it 'should get 200->201->400 valid' do
      expect { @multiple_resp_client.get200model201model_default_error400valid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 200->201->404->201 valid' do
      result = @multiple_resp_client.get200model_a201model_c404model_ddefault_error201valid_async().value!
      expect(result.response.status).to eq(201)
      expect(result.body).to be_an_instance_of(Models::C)
      expect(result.body.http_code.to_i).to eq(201)
    end

    it 'should get 200->201->404->404 valid' do
      expect { @multiple_resp_client.get200model_a201model_c404model_ddefault_error404valid_async().value! }.to raise_exception_with_code(404)
    end

    it 'should get 200->201->404->400 valid' do
      expect { @multiple_resp_client.get200model_a201model_c404model_ddefault_error400valid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 202->204->202 none' do
      expect { @multiple_resp_client.get202none204none_default_error202none_async().value! }.to raise_exception_with_code(202)
    end

    it 'should get 202->204->204 none' do
      expect { @multiple_resp_client.get202none204none_default_error204none_async().value! }.to raise_exception_with_code(204)
    end

    it 'should get 202->204->400 valid' do
      expect { @multiple_resp_client.get202none204none_default_error400valid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 202->204->202 invalid' do
      expect { @multiple_resp_client.get202none204none_default_none202invalid_async().value! }.to raise_exception_with_code(202)
    end

    it 'should get 202->204->204 none' do
      expect { @multiple_resp_client.get202none204none_default_none204none_async().value! }.to raise_exception_with_code(204)
    end

    it 'should get 202->204->400 none' do
      expect { @multiple_resp_client.get202none204none_default_none400none_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 202->204->400 invalid' do
      expect { @multiple_resp_client.get202none204none_default_none400invalid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get default 200 valid' do
      result = @multiple_resp_client.get_default_model_a200valid_async().value!
      expect(result.response.status).to eq(200)
    end

    it 'should get default 200 none' do
      expect { @multiple_resp_client.get_default_model_a200none_async().value! }.to raise_exception_with_code(200)
    end

    it 'should get default 400 valid' do
      expect { @multiple_resp_client.get_default_model_a400valid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get default 400 none' do
      expect { @multiple_resp_client.get_default_model_a400none_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get default 200 invalid' do
      expect { @multiple_resp_client.get_default_none200invalid_async().value! }.to raise_exception_with_code(200)
    end

    it 'should get default none 200 none' do
      expect { @multiple_resp_client.get_default_none200none_async().value! }.to raise_exception_with_code(200)
    end

    it 'should get default none 400 invalid' do
      expect { @multiple_resp_client.get_default_none400invalid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get default none 400 none' do
      expect { @multiple_resp_client.get_default_none400none_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 200 model_a 200 none' do
      result = @multiple_resp_client.get200model_a200none_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to be_nil
    end

    it 'should get 200 model_a 200 valid' do
      result = @multiple_resp_client.get200model_a200valid_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body.status_code.to_i).to eq(200)
    end

    it 'should get 200 model_a 200 invalid' do
      result = @multiple_resp_client.get200model_a200invalid_async().value!
      expect(result.response.status).to eq(200)
      expect(result.body).to be_an_instance_of(Models::A)
      expect(result.body.status_code).to be_nil
    end

    it 'should get 200 model_a 400 none' do
      expect { @multiple_resp_client.get200model_a400none_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 200 model_a 400 valid' do
      expect { @multiple_resp_client.get200model_a400valid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 200 model_a 400 invalid' do
      expect { @multiple_resp_client.get200model_a400invalid_async().value! }.to raise_exception_with_code(400)
    end

    it 'should get 200 model_a 202 valid' do
      expect { @multiple_resp_client.get200model_a202valid_async().value! }.to raise_exception_with_code(202)
    end
  end
end

end