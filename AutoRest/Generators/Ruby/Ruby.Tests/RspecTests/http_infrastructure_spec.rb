require 'rspec'
require_relative 'HttpInfrastructure/sdk_requirements'
require_relative './helper'
include MyNamespace

describe 'HttpInfrastructure' do

  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestHttpInfrastructureTestService.new(@credentials, @base_url)
    @failure_client = MyNamespace::HttpClientFailure.new(client)
    @redirect_client = MyNamespace::HttpRedirects.new(client)
    @retry_client = MyNamespace::HttpRetry.new(client)
    @server_fail_client = MyNamespace::HttpServerFailure.new(client)
    @success_client = MyNamespace::HttpSuccess.new(client)
    @multiple_resp_client = MyNamespace::MultipleResponses.new(client)
  end

  it 'should create test service' do
    expect { AutoRestHttpInfrastructureTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  context HttpClientFailure do
    it 'should send head 400' do
      expect { @failure_client.head400().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 400' do
      expect { @failure_client.get400().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should put 400' do
      expect { @failure_client.put400(true).value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should patch 400' do
      expect { @failure_client.patch400(true).value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should post 400' do
      expect { @failure_client.post400(true).value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should delete 400' do
      expect { @failure_client.delete400(true).value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should send head 401' do
      expect { @failure_client.head401().value! }.to raise_exception_with_code(Net::HTTPUnauthorized)
    end

    it 'should get 402' do
      expect { @failure_client.get402().value! }.to raise_exception_with_code(Net::HTTPPaymentRequired)
    end

    it 'should get 403' do
      expect { @failure_client.get403().value! }.to raise_exception_with_code(Net::HTTPForbidden)
    end

    it 'should put 404' do
      expect { @failure_client.put404(true).value! }.to raise_exception_with_code(Net::HTTPNotFound)
    end

    it 'should patch 405' do
      expect { @failure_client.patch405(true).value! }.to raise_exception_with_code(Net::HTTPMethodNotAllowed)
    end

    it 'should post 406' do
      expect { @failure_client.post406(true).value! }.to raise_exception_with_code(Net::HTTPNotAcceptable)
    end

    it 'should delete 407' do
      expect { @failure_client.delete407(true).value! }.to raise_exception_with_code(Net::HTTPProxyAuthenticationRequired)
    end

    it 'should put 409' do
      expect { @failure_client.put409(true).value! }.to raise_exception_with_code(Net::HTTPConflict)
    end

    it 'should send head 410' do
      expect { @failure_client.head410().value! }.to raise_exception_with_code(Net::HTTPGone)
    end

    it 'should get 411' do
      expect { @failure_client.get411().value! }.to raise_exception_with_code(Net::HTTPLengthRequired)
    end

    it 'should get 412' do
      expect { @failure_client.get412().value! }.to raise_exception_with_code(Net::HTTPPreconditionFailed)
    end

    it 'should put 413' do
      expect { @failure_client.put413(true).value! }.to raise_exception_with_code(Net::HTTPRequestEntityTooLarge)
    end

    it 'should patch 414' do
      expect { @failure_client.patch414(true).value! }.to raise_exception_with_code(Net::HTTPRequestURITooLong)
    end

    it 'should post 415' do
      expect { @failure_client.post415(true).value! }.to raise_exception_with_code(Net::HTTPUnsupportedMediaType)
    end

    it 'should get 416' do
      expect { @failure_client.get416().value! }.to raise_exception_with_code(Net::HTTPRequestedRangeNotSatisfiable)
    end

    it 'should delete 417' do
      expect { @failure_client.delete417(true).value! }.to raise_exception_with_code(Net::HTTPExpectationFailed)
    end

    it 'should send head 429' do
      expect { @failure_client.head429().value! }.to raise_exception_with_code(Net::HTTPTooManyRequests)
    end
  end

  context HttpRedirects do
    it 'should send head 300' do
      result = @redirect_client.head300().value!
      expect(result.response).to be_an_instance_of(Net::HTTPMultipleChoices)
    end

    it 'should get 300' do
      result = @redirect_client.get300().value!
      expect(result.response).to be_an_instance_of(Net::HTTPMultipleChoices)
      expect(result.body[0]).to eq("/http/success/get/200")
    end

    it 'should send head 301' do
      result = @redirect_client.head301().value!
      expect(result.response).to be_an_instance_of(Net::HTTPMovedPermanently)
    end

    it 'should get 301' do
      result = @redirect_client.get301().value!
      expect(result.response).to be_an_instance_of(Net::HTTPMovedPermanently)
    end

    it 'should put 301' do
      result = @redirect_client.put301(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPMovedPermanently)
    end

    it 'should send head 302' do
      result = @redirect_client.head302().value!
      expect(result.response).to be_an_instance_of(Net::HTTPFound)
    end

    it 'should get 302' do
      result = @redirect_client.get302().value!
      expect(result.response).to be_an_instance_of(Net::HTTPFound)
    end

    it 'should patch 302' do
      result = @redirect_client.patch302(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPFound)
    end

    it 'should post 303' do
      result = @redirect_client.post303(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPSeeOther)
    end

    it 'should send head 307' do
      result = @redirect_client.head307().value!
      expect(result.response).to be_an_instance_of(Net::HTTPTemporaryRedirect)
    end

    it 'should get 307' do
      result = @redirect_client.get307().value!
      expect(result.response).to be_an_instance_of(Net::HTTPTemporaryRedirect)
    end

    it 'should put 307' do
      result = @redirect_client.put307(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPTemporaryRedirect)
    end

    it 'should patch 307' do
      result = @redirect_client.patch307(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPTemporaryRedirect)
    end

    it 'should post 307' do
      result = @redirect_client.post307(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPTemporaryRedirect)
    end

    it 'should delete 307' do
      result = @redirect_client.delete307(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPTemporaryRedirect)
    end
  end

  context HttpRetry do
    it 'should send head 408' do
      result = @retry_client.head408().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should put 500' do
      result = @retry_client.put500(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should patch 500' do
      result = @retry_client.patch500(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should get 502' do
      result = @retry_client.get502().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should post 503' do
      result = @retry_client.post503(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should delete 503' do
      result = @retry_client.delete503(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should put 504' do
      result = @retry_client.put504(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should patch 504' do
      result = @retry_client.patch504(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end
  end

  context HttpServerFailure do
    it 'should send head 501' do
      expect { @server_fail_client.head501().value! }.to raise_exception_with_code(Net::HTTPNotImplemented)
    end

    it 'should send get 501' do
      expect { @server_fail_client.get501().value! }.to raise_exception_with_code(Net::HTTPNotImplemented)
    end

    it 'should send post 505' do
      expect { @server_fail_client.post505(true).value! }.to raise_exception_with_code(Net::HTTPVersionNotSupported)
    end

    it 'should send delete 505' do
      expect { @server_fail_client.delete505(true).value! }.to raise_exception_with_code(Net::HTTPVersionNotSupported)
    end
  end

  context HttpSuccess do
    it 'should send head 200' do
      result = @success_client.head200().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should get 200' do
      result = @success_client.get200().value!
      expect(result.body).to be_truthy
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should put 200' do
      result = @success_client.put200(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should patch 200' do
      result = @success_client.patch200(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should post 200' do
      result = @success_client.post200(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should delete 200' do
      result = @success_client.delete200(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should put 201' do
      result = @success_client.put201(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPCreated)
    end

    it 'should post 201' do
      result = @success_client.post201(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPCreated)
    end

    it 'should put 202' do
      result = @success_client.put202(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPAccepted)
    end

    it 'should patch 202' do
      result = @success_client.patch202(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPAccepted)
    end

    it 'should post 202' do
      result = @success_client.post202(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPAccepted)
    end

    it 'should delete 202' do
      result = @success_client.delete202(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPAccepted)
    end

    it 'should send head 204' do
      result = @success_client.head204().value!
      expect(result.response).to be_an_instance_of(Net::HTTPNoContent)
    end

    it 'should put 204' do
      result = @success_client.put204(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPNoContent)
    end

    it 'should patch 204' do
      result = @success_client.patch204(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPNoContent)
    end

    it 'should post 204' do
      result = @success_client.post204(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPNoContent)
    end

    it 'should delete 204' do
      result = @success_client.delete204(true).value!
      expect(result.response).to be_an_instance_of(Net::HTTPNoContent)
    end
  end

  context MultipleResponses do
    it 'should get 200->204->200 valid' do
      result = @multiple_resp_client.get200model204no_model_default_error200valid().value!.response
      expect(result).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should get 200->204->204 valid' do
      result = @multiple_resp_client.get200model204no_model_default_error204valid().value!.response
      expect(result).to be_an_instance_of(Net::HTTPNoContent)
    end

    it 'should get 200->204->201 invalid' do
      expect { @multiple_resp_client.get200model204no_model_default_error201invalid().value! }.to raise_exception_with_code(Net::HTTPCreated)
    end

    it 'should get 200->204->202 none' do
      expect { @multiple_resp_client.get200model204no_model_default_error202none().value! }.to raise_exception_with_code(Net::HTTPAccepted)
    end

    it 'should get 200->204->400 valid' do
      expect { @multiple_resp_client.get200model204no_model_default_error400valid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 200->201->200 valid' do
      result = @multiple_resp_client.get200model201model_default_error200valid().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
      expect(result.body).to be_an_instance_of(Models::A)
      expect(result.body.status_code.to_i).to eq(200)
    end

    it 'should get 200->201->201 valid' do
      result = @multiple_resp_client.get200model201model_default_error201valid().value!
      expect(result.response).to be_an_instance_of(Net::HTTPCreated)
      expect(result.body).to be_an_instance_of(Models::B)
      expect(result.body.text_status_code).to eq("Created")
    end

    it 'should get 200->201->400 valid' do
      expect { @multiple_resp_client.get200model201model_default_error400valid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 200->201->404->201 valid' do
      result = @multiple_resp_client.get200model_a201model_c404model_ddefault_error201valid().value!
      expect(result.response).to be_an_instance_of(Net::HTTPCreated)
      expect(result.body).to be_an_instance_of(Models::C)
      expect(result.body.http_code.to_i).to eq(201)
    end

    # it 'should get 200->201->404->404 valid' do
    #   pending("Figure out what behavior is correct, Ruby or C#!!")
    #   expect{@multiple_resp_client.get200model_a201model_c404model_ddefault_error404valid().value!}.to raise_exception_with_code(Net::HTTPNotFound)
    # end

    it 'should get 200->201->404->400 valid' do
      expect { @multiple_resp_client.get200model_a201model_c404model_ddefault_error400valid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 202->204->202 none' do
      expect { @multiple_resp_client.get202none204none_default_error202none().value! }.to raise_exception_with_code(Net::HTTPAccepted)
    end

    it 'should get 202->204->204 none' do
      expect { @multiple_resp_client.get202none204none_default_error204none().value! }.to raise_exception_with_code(Net::HTTPNoContent)
    end

    it 'should get 202->204->400 valid' do
      expect { @multiple_resp_client.get202none204none_default_error400valid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 202->204->202 invalid' do
      expect { @multiple_resp_client.get202none204none_default_none202invalid().value! }.to raise_exception_with_code(Net::HTTPAccepted)
    end

    it 'should get 202->204->204 none' do
      expect { @multiple_resp_client.get202none204none_default_none204none().value! }.to raise_exception_with_code(Net::HTTPNoContent)
    end

    it 'should get 202->204->400 none' do
      expect { @multiple_resp_client.get202none204none_default_none400none().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 202->204->400 invalid' do
      expect { @multiple_resp_client.get202none204none_default_none400invalid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get default 200 valid' do
      result = @multiple_resp_client.get_default_model_a200valid().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
    end

    it 'should get default 200 none' do
      expect { @multiple_resp_client.get_default_model_a200none().value! }.to raise_exception_with_code(Net::HTTPOK)
    end

    it 'should get default 400 valid' do
      expect { @multiple_resp_client.get_default_model_a400valid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get default 400 none' do
      expect { @multiple_resp_client.get_default_model_a400none().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get default 200 invalid' do
      expect { @multiple_resp_client.get_default_none200invalid().value! }.to raise_exception_with_code(Net::HTTPOK)
    end

    it 'should get default none 200 none' do
      expect { @multiple_resp_client.get_default_none200none().value! }.to raise_exception_with_code(Net::HTTPOK)
    end

    it 'should get default none 400 invalid' do
      expect { @multiple_resp_client.get_default_none400invalid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get default none 400 none' do
      expect { @multiple_resp_client.get_default_none400none().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 200 model_a 200 none' do
      result = @multiple_resp_client.get200model_a200none().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
      expect(result.body).to be_nil
    end

    it 'should get 200 model_a 200 valid' do
      result = @multiple_resp_client.get200model_a200valid().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
      expect(result.body.status_code.to_i).to eq(200)
    end

    it 'should get 200 model_a 200 invalid' do
      result = @multiple_resp_client.get200model_a200invalid().value!
      expect(result.response).to be_an_instance_of(Net::HTTPOK)
      expect(result.body).to be_an_instance_of(Models::A)
      expect(result.body.status_code).to be_nil
    end

    it 'should get 200 model_a 400 none' do
      expect { @multiple_resp_client.get200model_a400none().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 200 model_a 400 valid' do
      expect { @multiple_resp_client.get200model_a400valid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 200 model_a 400 invalid' do
      expect { @multiple_resp_client.get200model_a400invalid().value! }.to raise_exception_with_code(Net::HTTPBadRequest)
    end

    it 'should get 200 model_a 202 valid' do
      expect { @multiple_resp_client.get200model_a202valid().value! }.to raise_exception_with_code(Net::HTTPAccepted)
    end
  end
end