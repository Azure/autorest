# encoding: utf-8

$: << 'RspecTests/Generated/url_items'

require 'generated/url'

include UrlModule

describe Paths do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestUrlTestService.new(@credentials, @base_url)
    @paths_items_client = PathItems.new(@client)
  end

  it 'should create test service' do
    expect { AutoRestUrlTestService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get all with values' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = "globalStringQuery";

    result = @paths_items_client.get_all_with_values_async("localStringPath", "pathItemStringPath", "localStringQuery", "pathItemStringQuery").value!
    expect(result.response.status).to eq(200)
  end

  it 'should get global and local query null' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = nil;

    result = @paths_items_client.get_global_and_local_query_null_async("localStringPath", "pathItemStringPath", nil, "pathItemStringQuery").value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end

  it 'should get global query null' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = nil;

    result = @paths_items_client.get_global_query_null_async("localStringPath", "pathItemStringPath", "localStringQuery", "pathItemStringQuery").value!
    expect(result.response.status).to eq(200)
  end

  it 'should get local path item query null' do
    @client.global_string_path = "globalStringPath";
    @client.global_string_query = "globalStringQuery";

    result = @paths_items_client.get_local_path_item_query_null_async("localStringPath", "pathItemStringPath", nil, nil).value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end
end