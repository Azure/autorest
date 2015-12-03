# encoding: utf-8

$: << 'RspecTests/Generated/lro'

require 'rspec'
require 'lro'

include LroModule
include LroModule::Models

describe 'LongRunningOperation' do

  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestLongRunningOperationTestService.new(@credentials, @base_url)
    @client.long_running_operation_retry_timeout = 0
    @product = Product.new
    @product.location = "West US"
  end

  # Happy path tests
  it 'should wait for succeeded status for create operation' do
    result = @client.lros.put201creating_succeeded200(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should rise error on "failed" operation result' do
    expect { @client.lros.put201creating_failed200(@product).value! }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should wait for succeeded status for update operation' do
    result = @client.lros.put200updating_succeeded204(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should rise error on "canceled" operation result' do
    expect { @client.lros.put200acceptedcanceled200(@product).value! }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should retry on 200 server responce in POST request' do
    result = @client.lros.post202retry200(@product).value!
    expect(result.response.status).to eq(200)
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

  it 'should retry on 500 server responce in PUT request' do
    result = @client.lroretrys.put_async_relative_retry_succeeded(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  # TODO: Fix flakey test
  #it 'should serve async PUT operation failed' do
  #  expect { @client.lrosads.put_async_relative_retry400(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  #end

  it 'should serve success responce on initial DELETE request' do
    result = @client.lros.delete204succeeded().value!
    expect(result.response.status).to eq(204)
  end

  it 'should retry on 500 server responce in DELETE request' do
    result = @client.lroretrys.delete_async_relative_retry_succeeded().value!
    expect(result.response.status).to eq(200)
  end

  it 'should serve async POST operation' do
    result = @client.lroretrys.post_async_relative_retry_succeeded(@product).value!
    expect(result.response.status).to eq(200)
  end

  it 'should return payload on POST async request' do
    result = @client.lros.post200with_payload().value!
    expect(result.body.id).to eq(1)
  end

  # Retryable errors
  it 'should retry PUT request on 500 responce' do
    result = @client.lroretrys.put201creating_succeeded200(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should retry PUT request on 500 responce for async operation' do
    result = @client.lroretrys.put_async_relative_retry_succeeded(@product).value!
    expect(result.body.properties.provisioning_state).to eq("Succeeded")
  end

  it 'should retry DELETE request for provisioning status' do
    result = @client.lroretrys.delete_provisioning202accepted200succeeded().value!
    expect(result.response.status).to eq(200)
  end

  it 'should retry DELETE request on 500 responce' do
    result = @client.lroretrys.delete202retry200().value!
    expect(result.response.status).to eq(200)
  end

  it 'should retry POST request on 500 responce' do
    result = @client.lroretrys.post202retry200(@product).value!
    expect(result.response.status).to eq(200)
  end

  it 'should retry POST request on 500 responce for async operation' do
    result = @client.lroretrys.post_async_relative_retry_succeeded(@product).value!
    expect(result.response.status).to eq(200)
  end

  # Sad path tests
  it 'should rise error on responce 400 for PUT request' do
    expect { @client.lrosads.put_non_retry400(@product).value! }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should rise error if 400 responce comes in the middle of PUT operation' do
    expect { @client.lrosads.put_non_retry201creating400(@product).value! }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if 400 responce comes in the middle of async PUT operation' do
    expect { @client.lrosads.put_async_relative_retry400(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on responce 400 for DELETE request' do
    expect { @client.lrosads.delete_non_retry400().value! }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should rise error if 400 responce comes in the middle of DELETE operation' do
    expect{ @client.lrosads.delete_async_relative_retry400().value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if 400 responce comes from POST request' do
    expect{ @client.lrosads.post_non_retry400(@product).value! }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should rise error on responce 400 for POST request' do
    expect{ @client.lrosads.post202non_retry400(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if 400 responce comes in the middle of async POST operation' do
    expect{ @client.lrosads.post_async_relative_retry400(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no provisioning state in payload provided on PUT request' do
    expect{ @client.lrosads.put_error201no_provisioning_state_payload(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no state provided on PUT request' do
    expect{ @client.lrosads.put_async_relative_retry_no_status(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no provisioning state in payload provided on async PUT request' do
    expect{ @client.lrosads.put_async_relative_retry_no_status_payload(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid JSON responce on initial request' do
    expect{ @client.lrosads.put200invalid_json(@product).value! }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should rise error on invalid endpoint received in initial PUT request' do
    expect{ @client.lrosads.put_async_relative_retry_invalid_header(@product).value! }.to raise_exception(URI::Error)
  end

  it 'should rise error on invalid JSON responce in status polling request during PUT operation' do
    expect{ @client.lrosads.put_async_relative_retry_invalid_json_polling(@product).value! }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should rise error on invalid Location and Retry-After headers during DELETE operation' do
    expect{ @client.lrosads.delete202retry_invalid_header().value! }.to raise_exception(URI::Error)
  end

  it 'should rise error on invalid endpoint received in initial DELETE request' do
    expect{ @client.lrosads.delete_async_relative_retry_invalid_header().value! }.to raise_exception(URI::Error)
  end

  # TODO: Fix flakey test
  #it 'should rise error on invalid JSON responce in status polling request during DELETE operation' do
  #  expect{ @client.lrosads.delete_async_relative_retry_invalid_json_polling().value! }.to raise_exception(MsRest::DeserializationError)
  #end

  it 'should rise error on invalid Location and Retry-After headers during POST operation' do
    expect{ @client.lrosads.post202retry_invalid_header(@product).value! }.to raise_exception(URI::Error)
  end

  it 'should rise error on invalid endpoint received in initial POST request' do
    expect{ @client.lrosads.post_async_relative_retry_invalid_header(@product).value! }.to raise_exception(URI::Error)
  end

  it 'should rise error on invalid JSON responce in status polling request during POST operation' do
    expect{ @client.lrosads.post_async_relative_retry_invalid_json_polling(@product).value! }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should not rise error on DELETE operation with 204 responce without location provided' do
    result = @client.lrosads.delete204succeeded().value!
    expect(result.response.status).to eq(204)
  end

  # TODO: Fix flakey test
  #it 'should rise error on no status provided for DELETE async operation' do
  #  expect{ @client.lrosads.delete_async_relative_retry_no_status().value! }.to raise_exception(MsRestAzure::AzureOperationError)
  #end

  it 'should rise error if no location provided' do
    pending 'fails for in travis'
    fail
    expect { @client.lrosads.post202no_location(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no payload provided on POST async retry request' do
    expect{ @client.lrosads.post_async_relative_retry_no_payload(@product).value! }.to raise_exception(MsRestAzure::AzureOperationError)
  end
end
