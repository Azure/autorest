require 'rspec'
require 'client_runtime'
require 'securerandom'
require_relative 'Paging/sdk_requirements'


describe Paging do
  before(:all) do
    @base_url = ENV['StubServerURI']
    @client = AutoRestPagingTestService.new(@base_url, TokenCloudCredentials.new(SecureRandom.uuid, SecureRandom.uuid))
  end
  # Paging happy path tests
  it 'should get single pages' do
    result = @client.paging.get_single_pages().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.nextLink).to be_nil
  end
  it 'should get multiple pages' do
    result = @client.paging.get_multiple_pages().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.nextLink).not_to be_nil
    count = 1
    while result.body.nextLink != nil do
      result = @client.paging.get_multiple_pages_next(result.body.nextLink).value!.body
      count += 1
    end
    expect(count).to eq(10)
  end
  it 'should get multiple pages retry first' do
    result = @client.paging.get_multiple_pages_retry_first().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.nextLink).not_to be_nil
    count = 1
    while result.body.nextLink != nil do
      result = @client.paging.get_multiple_pages_retry_first_next(result.body.nextLink).value!.body
      count += 1
    end
    expect(count).to eq(10)
  end
  it 'should get multiple pages retry second' do
    result = @client.paging.get_multiple_pages_retry_second().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.nextLink).not_to be_nil
    count = 1
    while result.body.nextLink != nil do
      result = @client.paging.get_multiple_pages_retry_second_next(result.body.nextLink).value!.body
      count += 1
    end
    expect(count).to eq(10)
  end
  # Paging sad path tests
  it 'should get single pages failure' do
    expect{ @client.paging.get_single_pages_failure().value! }.to raise_exception(CloudException)
  end
  it 'should get multiple pages failure' do
    result = @client.paging.get_multiple_pages_failure().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.nextLink).not_to be_nil
    expect{ @client.paging.get_multiple_pages_failure_next(result.body.nextLink).value!.body }.to raise_exception(CloudException)
  end
  it 'should get multiple pages failure URI' do
    result = @client.paging.get_multiple_pages_failure_uri().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.nextLink).not_to be_nil
    expect{ @client.paging.get_multiple_pages_failure_uri_next(result.body.nextLink).value!.body }.to raise_exception(UriFormatException)
  end
end