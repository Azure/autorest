require_relative 'UrlItems/sdk_requirements'
include MyNamespace

describe Paths do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = MyNamespace::AutoRestUrlTestService.new(@credentials, @base_url)
    @paths_items_client = MyNamespace::PathItems.new(@client)
  end

  it 'should create test service' do
    expect { MyNamespace::AutoRestUrlTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get all with values' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = "globalStringQuery";

    result = @paths_items_client.get_all_with_values("localStringPath", "pathItemStringPath", "localStringQuery", "pathItemStringQuery").value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get global and local query null' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = nil;

    result = @paths_items_client.get_global_and_local_query_null("localStringPath", "pathItemStringPath", nil, "pathItemStringQuery").value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to be_nil
  end

  it 'should get global query null' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = nil;

    result = @paths_items_client.get_global_query_null("localStringPath", "pathItemStringPath", "localStringQuery", "pathItemStringQuery").value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end

  it 'should get local path item query null' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = "globalStringQuery";

    result = @paths_items_client.get_local_path_item_query_null("localStringPath", "pathItemStringPath", nil, nil).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to be_nil
  end
end