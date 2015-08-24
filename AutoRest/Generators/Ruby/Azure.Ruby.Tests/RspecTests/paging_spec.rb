# encoding: utf-8

$: << 'RspecTests/Generated/paging'

require 'rspec'
require 'paging'

include PagingModule

describe 'Paging' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestPagingTestService.new(@credentials, @base_url)
  end

  # Paging happy path tests
  it 'should get single pages' do
    result = @client.paging.get_single_pages().value!
    expect(result.response.status).to eq(200)
    expect(result.body.next_link).to be_nil
  end

  it 'should get multiple pages' do
    result = @client.paging.get_multiple_pages().value!
    expect(result.response.status).to eq(200)
    expect(result.body.next_link).not_to be_nil

    count = 1
    while result.body.next_link != nil do
      result = @client.paging.get_multiple_pages_next(result.body.next_link).value!
      count += 1
    end

    expect(count).to eq(10)
  end

  it 'should get multiple pages retry first' do
    result = @client.paging.get_multiple_pages_retry_first().value!
    expect(result.response.status).to eq(200)
    expect(result.body.next_link).not_to be_nil

    count = 1
    while result.body.next_link != nil do
      result = @client.paging.get_multiple_pages_retry_first_next(result.body.next_link).value!
      count += 1
    end

    expect(count).to eq(10)
  end

  it 'should get multiple pages retry second' do
    result = @client.paging.get_multiple_pages_retry_second().value!
    expect(result.response.status).to eq(200)
    expect(result.body.next_link).not_to be_nil

    count = 1
    while result.body.next_link != nil do
      result = @client.paging.get_multiple_pages_retry_second_next(result.body.next_link).value!
      count += 1
    end

    expect(count).to eq(10)
  end

  # Paging sad path tests
  it 'should get single pages failure' do
    expect { @client.paging.get_single_pages_failure().value! }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get multiple pages failure' do
    result = @client.paging.get_multiple_pages_failure().value!
    expect(result.response.status).to eq(200)
    expect(result.body.next_link).not_to be_nil

    expect { @client.paging.get_multiple_pages_failure_next(result.body.next_link).value! }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get multiple pages failure URI' do
    result = @client.paging.get_multiple_pages_failure_uri().value!
    expect(result.response.status).to eq(200)
    expect(result.body.next_link).not_to be_nil

    expect { @client.paging.get_multiple_pages_failure_uri_next(result.body.next_link).value! }.to raise_exception(URI::Error)
  end
end