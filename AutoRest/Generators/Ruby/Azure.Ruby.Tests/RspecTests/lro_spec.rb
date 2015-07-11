require 'rspec'
require 'securerandom'
require_relative 'Lro/sdk_requirements'
include MyNamespace

describe 'LongRunningOperation' do

  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	dummySubscription = '1-1-1-1'
	@credentials = ClientRuntimeAzure::TokenCloudCredentials.new(dummySubscription, dummyToken)

    @client = AutoRestLongRunningOperationTestService.new(@credentials, @base_url)
    @client.long_running_operation_retry_timeout = 0
    @product = Models::Product.new
    @product.location = "West US"
  end

  # Happy path tests
  it 'should wait for succeeded status for create operation' do
    result = @client.lros.put201creating_succeeded200(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should rise error on "failed" operation result' do
    expect { @client.lros.put201creating_failed200(@product).value! }.to raise_error(ClientRuntimeAzure::CloudError)
  end

  it 'should wait for succeeded status for update operation' do
    result = @client.lros.put200updating_succeeded204(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should rise error on "canceled" operation result' do
    expect { @client.lros.put200acceptedcanceled200(@product).value! }.to raise_error(ClientRuntimeAzure::CloudError)
  end

  it 'should retry on 200 server responce in POST request' do
    result = @client.lros.post202retry200(@product).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should serve success responce on initial PUT request' do
    result = @client.lros.put200succeeded(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should serve success responce on initial request without provision state' do
    result = @client.lros.put200succeeded_no_state(@product).value!
    expect(result.body.id).to eq("100")
    expect(result.body.properties).to eq(nil)
  end

  it 'should serve 202 on initial responce and status responce without provision state' do
    result = @client.lros.put202retry200(@product).value!
    expect(result.body.id).to eq("100")
    expect(result.body.properties).to eq(nil)
  end

  # it 'should retry on 500 server responce in PUT request' do
  #   result = @client.lroretrys.put_async_relative_retry_succeeded(@product).value!.body
  #   expect(body.provisioningState).to eq("Succeeded")
  # end

  # it 'should serve async PUT operation' do
  #   result = @client.lros.put_async_absolute_no_retry_succeeded(@product).value!.body
  #   expect(body.provisioningState).to eq("Succeeded")
  # end

  # it 'should serve async PUT operation failed' do
  #   expect{ @client.lrosads.put_async_relative_retry400(@product).value! }.to raise_exception(CloudError)
  # end

  # it 'should serve success responce on initial DELETE request' do
  #   result = @client.lros.delete_204_suceeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should serve async DELETE operation' do
  #   result = @client.lros.delete_async_absolute_no_retry_succeeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should serve async DELETE operation canceled' do
  #   expect{ @client.lros.delete_async_relative_retry_canceled().value! }.to raise_exception(CloudException, /Long running operation failed/)
  # end
  # it 'should serve async DELETE operation failed' do
  #   expect{ @client.lros.delete_async_relative_retry_failed().value! }.to raise_exception(CloudException, /Long running operation failed/)
  # end
  # it 'should retry on 500 server responce in DELETE request' do
  #   result = @client.lros.delete_async_relative_retry_succeeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should serve async POST operation failed' do
  #   expect{ @client.lros.post_async_relative_retry_failed().value! }.to raise_exception(CloudException, /Long running operation failed/)
  # end
  # it 'should serve async POST operation canceled' do
  #   expect{ @client.lros.post_async_relative_retry_canceled().value! }.to raise_exception(CloudException, /Long running operation failed  with status 'Canceled'/)
  # end
  # it 'should serve async POST operation' do
  #   result = @client.lros.post_async_relative_retry_succeeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should return payload on POST async request' do
  #   result = @client.lros.post_200_with_payload().value!.body
  #   expect(result.id).to eq(1)
  # end
  # # Retryable errors
  # it 'should retry PUT request on 500 responce' do
  #   result = @client.lro_retrys.put_201_creating_succeeded_200(@product).value!.body
  #   expect(body.provisioningState).to eq("Succeeded")
  # end
  # it 'should retry PUT request on 500 responce for async operation' do
  #   result = @client.lro_retrys.put_async_relative_retry_succeeded(@product).value!.body
  #   expect(body.provisioningState).to eq("Succeeded")
  # end
  # it 'should retry DELETE request for provisioning status' do
  #   result = @client.lros_retrys.delete_provisioning_202_accepted_200_succeeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should retry DELETE request on 500 responce' do
  #   result = @client.lros_retrys.delete_202_retry_200().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should retry DELETE request on 500 responce for async operation' do
  #   result = @client.lros_retrys.delete_async_relative_retry_succeeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should retry POST request on 500 responce' do
  #   result = @client.lros_retrys.post_202_retry_200(@product).value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should retry POST request on 500 responce for async operation' do
  #   result = @client.lros_retrys.post_async_relative_retry_succeeded(@product).value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end

  # #Sad path tests
  # it 'should rise error on responce 400 for PUT request' do
  #   expect{@client.lro_sads.put_non_retry_400(@product).value! }.to raise_exception(ClientRuntime::CloudException, /Expected/)
  # end
  # it 'should rise error if 400 responce comes in the middle of PUT operation' do
  #   expect{@client.lro_sads.put_non_retry_201_creating_400(@product).value!}.to raise_error(ClientRuntime::CloudException, "Error from the server")
  # end
  # it 'should rise error if 400 responce comes in the middle of async PUT operation' do
  #   expect{@client.lro_sads.put_async_relative_retry_400(@product).value! }.to raise_exception(ClientRuntime::CloudException, "Long running operation failed with status 'BadRequest'.")
  # end
  # it 'should rise error on responce 400 for DELETE request' do
  #   expect{ @client.lro_sads.delete_non_retry_400().value! }.to raise_exception(ClientRuntime::CloudException, /Expected/)
  # end
  # it 'should rise error if 400 responce comes in the middle of DELETE operation' do
  #   expect{ @client.lro_sads.delete_async_relative_retry_400().value! }.to raise_exception(ClientRuntime::CloudException, "Long running operation failed with status 'BadRequest'.")
  # end
  # it 'should rise error if 400 responce comes in the middle of async DELETE operation' do
  #   expect{ @client.lro_sads.post_non_retry_400(@product).value! }.to raise_exception(ClientRuntime::CloudException, "Expected bad request message")
  # end
  # it 'should rise error on responce 400 for POST request' do
  #   expect{ @client.lro_sads.post_202_non_retry_400(@product).value! }.to raise_exception(ClientRuntime::CloudException, "Long running operation failed with status 'BadRequest'.")
  # end
  # it 'should rise error if 400 responce comes in the middle of async POST operation' do
  #   expect{ @client.lro_sads.post_async_relative_retry_400(@product).value! }.to raise_exception(ClientRuntime::CloudException, "Long running operation failed with status 'BadRequest'.")
  # end
  # it 'should rise error if no provisioning state in payload provided on PUT request' do
  #   expect{ @client.lro_sads.put_error_201_no_provisioning_state_payload(@product).value! }.to raise_exception(ClientRuntime::CloudException, "The response from long running operation does not contain a body.")
  # end
  # it 'should rise error if no state provided on PUT request' do
  #   expect{ @client.lro_sads.put_async_relative_retry_no_status(@product).value! }.to raise_exception(ClientRuntime::CloudException, "The response from long running operation does not contain a body.")
  # end
  # it 'should rise error if no provisioning state in payload provided on async PUT request' do
  #   expect{ @client.lro_sads.put_async_relative_retry_no_status_payload(@product).value! }.to raise_exception(ClientRuntime::CloudException, "The response from long running operation does not contain a body.")
  # end
  # it 'should rise error on invalid JSON responce on initial request' do
  #   expect{ @client.lro_sads.put_200_invalid_json(@product).value! }.to raise_exception(ClientRuntime::CloudException)
  # end
  # it 'should rise error on invalid endpoint received in initial PUT request' do
  #   expect{ @client.lro_sads.put_async_relative_retry_invalid_header(@product).value! }.to raise_exception(ClientRuntime::UriFormatException)
  # end
  # it 'should rise error on invalid JSON responce in status polling request during PUT operation' do
  #   expect{ @client.lro_sads.put_async_relative_retry_invalid_json_polling(@product).value! }.to raise_exception(ClientRuntime::JsonSerializationException)
  # end
  # it 'should rise error on invalid Location and Retry-After headers during DELETE operation' do
  #   expect{ @client.lro_sads.delete_202_retry_invalid_header().value! }.to raise_exception(ClientRuntime::UriFormatException)
  # end
  # it 'should rise error on invalid endpoint received in initial DELETE request' do
  #   expect{ @client.lro_sads.delete_async_relative_retry_invalid_header().value! }.to raise_exception(ClientRuntime::UriFormatException)
  # end
  # it 'should rise error on invalid JSON responce in status polling request during DELETE operation' do
  #   expect{ @client.lro_sads.delete_async_relative_retry_invalid_json_polling().value! }.to raise_exception(ClientRuntime::JsonSerializationException)
  # end
  # it 'should rise error on invalid Location and Retry-After headers during POST operation' do
  #   expect{ @client.lro_sads.post_202_retry_invalid_header().value! }.to raise_exception(ClientRuntime::UriFormatException)
  # end
  # it 'should rise error on invalid endpoint received in initial POST request' do
  #   expect{ @client.lro_sads.post_async_relative_retry_invalid_header().value! }.to raise_exception(ClientRuntime::UriFormatException)
  # end
  # it 'should rise error on invalid JSON responce in status polling request during POST operation' do
  #   expect{ @client.lro_sads.post_async_relative_retry_invalid_json_polling().value! }.to raise_exception(ClientRuntime::JsonSerializationException)
  # end
  # it 'should not rise error on DELETE operation with 204 responce without location provided' do
  #   result = @client.lro_sads.delete_204_succeeded().value!.response
  #   expect(result).to be_an_instance_of(Net::HTTPOK)
  # end
  # it 'should rise error on no status provided for DELETE async operation' do
  #   expect{ @client.lro_sads.delete_async_relative_retry_no_status().value! }.to raise_exception(CloudException, "The response from long running operation does not contain a body.")
  # end
  # it 'should rise error if no location provided' do
  #   expect{ @client.lro_sads.post_202_no_location().value! }.to raise_exception(ClientRuntime::CloudException, /Location header is missing from long running operation./)
  # end
  # it 'should rise error if no payload provided on POST async retry request' do
  #   expect{ @client.lro_sads.post_async_relative_retry_no_payload().value! }.to raise_exception(ClientRuntime::CloudException, "The response from long running operation does not contain a body.")
  # end
end