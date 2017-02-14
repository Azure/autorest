# encoding: utf-8

$: << 'RspecTests/Generated/lro'

require 'rspec'
require 'generated/lro'

include LroModule
include LroModule::Models

describe 'Long Running Operation' do
  before(:all) do
    base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    credentials = MsRest::TokenCredentials.new(dummyToken)

    test_client = AutoRestLongRunningOperationTestService.new(credentials, base_url)
    test_client.long_running_operation_retry_timeout = 0
    @lros_client = test_client.lros

    @product = Product.new
    @product.location = "West US"

    @sku = Sku.new
    @sku.name = 'doesNotMatter'
    @sku.id = 'doesNotMatter'
  end

  # Happy path tests
  it 'should wait for succeeded status for create operation' do
    result = @lros_client.put201creating_succeeded200_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should rise error on "failed" operation result' do
    expect { @lros_client.put201creating_failed200(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should wait for succeeded status for update operation' do
    result = @lros_client.put200updating_succeeded204_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should rise error on "canceled" operation result' do
    expect { @lros_client.put200acceptedcanceled200(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should retry on 202 server response in POST request' do
    result = @lros_client.post202retry200_async(@product).value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should not retry on 202 server response in POST request' do
    result = @lros_client.post202no_retry204_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(204)
  end

  it 'should serve success response on initial PUT request' do
    result = @lros_client.put200succeeded_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should serve success response on initial request without provision state' do
    result = @lros_client.put200succeeded_no_state_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.id).to eq("100")
    expect(result.body.provisioning_state).to eq(nil)
  end

  it 'should serve 202 on initial response and status response without provision state' do
    result = @lros_client.put202retry200_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.id).to eq("100")
    expect(result.body.provisioning_state).to eq(nil)
  end

  it 'should serve success response on initial DELETE request' do
    result = @lros_client.delete204succeeded_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(204)
  end

  it 'should return payload on POST async request' do
    result = @lros_client.post200with_payload_async().value!
    expect(result.body).to be_instance_of(Sku)
    expect(result.body.id).to eq(1)
  end

  it 'should succeed for put async retry' do
    result = @lros_client.put_async_retry_succeeded_async(@product).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for put async no retry' do
    result = @lros_client.put_async_no_retry_succeeded_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(200)
  end

  it 'should fail for put async retry' do
    expect { @lros_client.put_async_retry_failed(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should fail for put async no retry canceled' do
    expect { @lros_client.put_async_no_retrycanceled(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should succeed for post async retry' do
    result = @lros_client.post_async_retry_succeeded_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(200)
  end

  it 'should succeed for post async no retry' do
    result = @lros_client.post_async_no_retry_succeeded_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(200)
  end

  it 'should fail for post async retry' do
    expect { @lros_client.post_async_retry_failed(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should fail for post async retry canceled' do
    expect { @lros_client.post_async_retrycanceled(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should succeed for put no header in retry' do
    result = @lros_client.put_no_header_in_retry_async(@product).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for put async no header in retry' do
    result = @lros_client.put_async_no_header_in_retry_async(@product).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for delete no header in retry' do
    result = @lros_client.delete_no_header_in_retry_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(204)
  end

  it 'should succeed for delete async no header in retry' do
    result = @lros_client.delete_async_no_header_in_retry_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should succeed for put sub resource' do
    result = @lros_client.put_sub_resource_async(@product).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(SubProduct)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for put async sub resource' do
    result = @lros_client.put_async_sub_resource_async(@product).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(SubProduct)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for put non resource' do
    result = @lros_client.put_non_resource_async(@sku).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Sku)
    expect(result.body.id).to eq('100')
    expect(result.body.name).to eq('sku')
  end

  it 'should succeed for put async non resource' do
    result = @lros_client.put_async_non_resource_async(@sku).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Sku)
    expect(result.body.id).to eq('100')
    expect(result.body.name).to eq('sku')
  end

  it 'should succeed for delete provisioning 202 accepted 200' do
    result = @lros_client.delete_provisioning202accepted200succeeded_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for delete provisioning 202 deleting failed 200' do
    result = @lros_client.delete_provisioning202deleting_failed200_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Failed")
  end

  it 'should succeed for delete provisioning 202 deleting canceled 200' do
    result = @lros_client.delete_provisioning202deletingcanceled200_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Canceled")
  end

  it 'should succeed for delete 204' do
    result = @lros_client.delete204succeeded_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(204)
  end

  it 'should succeed for delete 202 retry 200' do
    result = @lros_client.delete202retry200_async().value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(200)
  end

  it 'should succeed for delete 202 no retry 204' do
    result = @lros_client.delete202no_retry204_async().value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(204)
  end

  it 'should succeed for delete async retry' do
    result = @lros_client.delete_async_retry_succeeded_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should succeed for delete async no retry' do
    result = @lros_client.delete_async_no_retry_succeeded_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should fail for delete async retry failed' do
    expect { @lros_client.delete_async_retry_failed() }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should fail for delete async retry canceled' do
    expect { @lros_client.delete_async_retrycanceled() }.to raise_error(MsRestAzure::AzureOperationError)
  end
end

describe 'Long Running Operation with retry' do
  before(:all) do
    base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    credentials = MsRest::TokenCredentials.new(dummyToken)

    test_client = AutoRestLongRunningOperationTestService.new(credentials, base_url)
    test_client.long_running_operation_retry_timeout = 0
    @lroretrys_client = test_client.lroretrys
    @product = Product.new
    @product.location = "West US"
  end

  # Retryable errors
  it 'should retry PUT request on 500 response' do
    result = @lroretrys_client.put201creating_succeeded200_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should retry PUT request on 500 response for async operation' do
    result = @lroretrys_client.put_async_relative_retry_succeeded_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should retry DELETE request for provisioning status' do
    result = @lroretrys_client.delete_provisioning202accepted200succeeded_async().value!
    expect(result.body).to be_instance_of(Product)
    expect(result.response.status).to eq(200)
  end

  it 'should retry DELETE request on 500 response' do
    result = @lroretrys_client.delete202retry200_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should retry POST request on 500 response' do
    result = @lroretrys_client.post202retry200_async(@product).value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should retry POST request on 500 response for async operation' do
    result = @lroretrys_client.post_async_relative_retry_succeeded_async(@product).value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should retry on 500 server response in PUT request' do
    result = @lroretrys_client.put_async_relative_retry_succeeded_async(@product).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should retry on 500 server response in DELETE request' do
    result = @lroretrys_client.delete_async_relative_retry_succeeded_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end
end

describe 'Long Running Operation with ads' do
  before(:all) do
    base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    credentials = MsRest::TokenCredentials.new(dummyToken)

    test_client = AutoRestLongRunningOperationTestService.new(credentials, base_url)
    test_client.long_running_operation_retry_timeout = 0
    @lroads_client = test_client.lrosads
    @product = Product.new
    @product.location = "West US"
  end

  # Sad path tests
  it 'should rise error on response 400 for PUT request' do
    expect { @lroads_client.put_non_retry400(@product) }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should rise error if 400 response comes in the middle of PUT operation' do
    expect { @lroads_client.put_non_retry201creating400(@product) }.to raise_error(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if 400 response comes in the middle of async PUT operation' do
    expect { @lroads_client.put_async_relative_retry400(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on response 400 for DELETE request' do
    expect { @lroads_client.delete_non_retry400() }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should rise error if 400 response comes in the middle of DELETE operation' do
    expect{ @lroads_client.delete_async_relative_retry400() }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if 400 response comes from POST request' do
    expect{ @lroads_client.post_non_retry400(@product) }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should rise error on response 400 for POST request' do
    expect{ @lroads_client.post202non_retry400(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if 400 response comes in the middle of async POST operation' do
    expect{ @lroads_client.post_async_relative_retry400(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no provisioning state in payload provided on PUT request' do
    expect{ @lroads_client.put_error201no_provisioning_state_payload(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no state provided on PUT request' do
    expect{ @lroads_client.put_async_relative_retry_no_status(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no provisioning state in payload provided on async PUT request' do
    expect{ @lroads_client.put_async_relative_retry_no_status_payload(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid JSON response on initial request' do
    expect{ @lroads_client.put200invalid_json(@product) }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should rise error on invalid endpoint received in initial PUT request' do
    expect{ @lroads_client.put_async_relative_retry_invalid_header(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid JSON response in status polling request during PUT operation' do
    expect{ @lroads_client.put_async_relative_retry_invalid_json_polling(@product) }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should rise error on invalid Location and Retry-After headers during DELETE operation' do
    expect{ @lroads_client.delete202retry_invalid_header() }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid endpoint received in initial DELETE request' do
    expect{ @lroads_client.delete_async_relative_retry_invalid_header() }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid JSON response in status polling request during DELETE operation' do
   expect{ @lroads_client.delete_async_relative_retry_invalid_json_polling() }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should rise error on invalid Location and Retry-After headers during POST operation' do
    expect{ @lroads_client.post202retry_invalid_header(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid endpoint received in initial POST request' do
    expect{ @lroads_client.post_async_relative_retry_invalid_header(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error on invalid JSON response in status polling request during POST operation' do
    expect{ @lroads_client.post_async_relative_retry_invalid_json_polling(@product) }.to raise_exception(MsRest::DeserializationError)
  end

  it 'should not rise error on DELETE operation with 204 response without location provided' do
    result = @lroads_client.delete204succeeded_async().value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(204)
  end

  it 'should rise error on no status provided for DELETE async operation' do
   expect{ @lroads_client.delete_async_relative_retry_no_status() }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no location provided' do
    pending 'fails for in travis'
    fail
    expect { @lroads_client.post202no_location(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no payload provided on POST async retry request' do
    expect{ @lroads_client.post_async_relative_retry_no_payload(@product) }.to raise_exception(MsRestAzure::AzureOperationError)
  end

  it 'should rise error if no payload provided on DELETE non retry request' do
    expect{ @lroads_client.delete202non_retry400() }.to raise_exception(MsRestAzure::AzureOperationError)
  end
end

describe 'Long Running Operation with custom header' do
  before(:all) do
    base_url = ENV['StubServerURI']
    dummyToken = 'dummy12321343423'
    credentials = MsRest::TokenCredentials.new(dummyToken)

    test_client = AutoRestLongRunningOperationTestService.new(credentials, base_url)
    test_client.long_running_operation_retry_timeout = 0
    @lros_custom_header_client = test_client.lros_custom_header
    @product = Product.new
    @product.location = "West US"
    @custom_header = { 'x-ms-client-request-id' => '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0' }
  end

  it 'should succeed for custom header put async' do
    result = @lros_custom_header_client.put_async_retry_succeeded_async(@product, @custom_header).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for custom header post async' do
    result = @lros_custom_header_client.post_async_retry_succeeded_async(@product, @custom_header).value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end

  it 'should succeed for custom header put' do
    result = @lros_custom_header_client.put201creating_succeeded200_async(@product, @custom_header).value!
    expect(result.body).to be_instance_of(Product)
    expect(result.body.provisioning_state).to eq("Succeeded")
  end

  it 'should succeed for custom header put with begin' do
    result = @lros_custom_header_client.begin_put201creating_succeeded200(@product, @custom_header)
    expect(result).to be_instance_of(Product)
    expect(result.provisioning_state).to eq("Creating")
  end

  it 'should succeed for custom header post' do
    result = @lros_custom_header_client.post202retry200_async(@product, @custom_header).value!
    expect(result.body).to be_nil
    expect(result.response.status).to eq(200)
  end
end