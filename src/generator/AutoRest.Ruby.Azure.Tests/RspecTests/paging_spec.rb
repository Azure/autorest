# encoding: utf-8

$: << 'RspecTests/Generated/paging'

require 'rspec'
require 'generated/paging'

include PagingModule

describe 'Paging' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestPagingTestService.new(@credentials, @base_url)

    @tenant = 'test_user'
    @api_version = '1.6'
  end

  # Paging happy path tests
  it 'should get single pages' do
    all_items = @client.paging.get_single_pages()
    expect(all_items.count).to eq(1)
    expect(all_items.is_a? Array)
    expect(all_items.first.is_a? PagingModule::Models::Product)
  end

  it 'should get multiple pages' do
    all_items = @client.paging.get_multiple_pages() #returns items from all the pages
    items_count = all_items.count
    expect(items_count).to eq(10)
    expect(all_items.is_a? Array)
    expect(all_items.first.is_a? PagingModule::Models::Product)
  end

  it 'should get multiple pages - lazy' do
    page = @client.paging.get_multiple_pages_as_lazy()
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.next_link).not_to be_nil
    items = page.values
    while page.next_link != nil do
      page = page.get_next_page
      items.concat(page.values)
    end
    expect(items.count).to eq(10)
  end

  it 'should get multiple pages' do
    all_items = @client.paging.get_odata_multiple_pages() #returns items from all the pages
    items_count = all_items.count
    expect(items_count).to eq(10)
    expect(all_items.is_a? Array)
    expect(all_items.first.is_a? PagingModule::Models::Product)
  end

  it 'should get multiple pages with odata - lazy ' do
    page = @client.paging.get_odata_multiple_pages_as_lazy()
    expect(page.is_a? PagingModule::Models::OdataProductResult)
    expect(page.odatanext_link).not_to be_nil
    items = page.values
    while page.odatanext_link != nil do
      page = page.get_next_page
      items.concat(page.values)
    end
    expect(items.count).to eq(10)
  end

  it 'should get multiple pages with offset' do
    options = PagingModule::Models::PagingGetMultiplePagesWithOffsetOptions.new
    options.offset = 100
    all_items = @client.paging.get_multiple_pages_with_offset(options)
    expect(all_items.count).to eq(10)
    expect(all_items.is_a? Array)
    expect(all_items.first.is_a? PagingModule::Models::Product)
    expect(all_items.last.properties.id).to eq (110)
  end

  it 'should get multiple pages with offset - lazy' do
    options = PagingModule::Models::PagingGetMultiplePagesWithOffsetOptions.new
    options.offset = 100
    page = @client.paging.get_multiple_pages_with_offset_as_lazy(options)
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.next_link).not_to be_nil
    items = page.values
    while page.next_link != nil do
      page = page.get_next_page
      items.concat(page.values)
    end
    expect(items.count).to eq(10)
    expect(page.values.last.properties.id).to eq (110)
  end

  it 'should get multiple pages retry first' do
    all_items = @client.paging.get_multiple_pages_retry_first()
    expect(all_items.count).to eq(10)
    expect(all_items.is_a? Array)
    expect(all_items.first.is_a? PagingModule::Models::Product)
  end

  it 'should get multiple pages retry first - lazy' do
    page = @client.paging.get_multiple_pages_retry_first_as_lazy
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.next_link).not_to be_nil
    items = page.values
    while page.next_link != nil do
      page = page.get_next_page
      items.concat(page.values)
    end
    expect(items.count).to eq(10)

  end

  it 'should get multiple pages retry second' do
    all_items = @client.paging.get_multiple_pages_retry_second()
    expect(all_items.count).to eq(10)
    expect(all_items.is_a? Array)
    expect(all_items.first.is_a? PagingModule::Models::Product)
  end

  it 'should get multiple pages retry second - lazy' do
    page = @client.paging.get_multiple_pages_retry_second_as_lazy
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.next_link).not_to be_nil
    items = page.values
    while page.next_link != nil do
      page = page.get_next_page
      items.concat(page.values)
    end
    expect(items.count).to eq(10)
  end

  it 'should get multiple pages with fragmented next link - lazy' do
    page = @client.paging.get_multiple_pages_fragment_next_link_as_lazy(@api_version, @tenant)
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.odatanext_link).not_to be_nil

    all_item = page.get_all_items
    expect(all_item.count).to eq(10)
  end

  it 'should get multiple pages with fragmented next link' do
    all_item = @client.paging.get_multiple_pages_fragment_next_link(@api_version, @tenant)
    expect(all_item[0].is_a? PagingModule::Models::ProductResult)
    expect(all_item.count).to eq(10)
  end

  it 'should get multiple pages with fragmented grouped next link' do
    grouped_param = PagingModule::Models::CustomParameterGroup.new
    grouped_param.api_version = '1.6'
    grouped_param.tenant = 'test_user'
    all_item = @client.paging.get_multiple_pages_fragment_with_grouping_next_link(grouped_param)
    expect(all_item[0].is_a? PagingModule::Models::ProductResult)
    expect(all_item.count).to eq(10)
  end

  # Paging sad path tests
  it 'should get single pages failure' do
    expect { @client.paging.get_single_pages_failure_as_lazy }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get single pages failure' do
    expect { @client.paging.get_single_pages_failure() }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get multiple pages failure' do
    expect {  @client.paging.get_multiple_pages_failure()}.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get multiple pages failure - lazy' do
    page = @client.paging.get_multiple_pages_failure_as_lazy
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.next_link).not_to be_nil

    expect { page.get_next_page }.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get multiple pages failure URI' do
    expect {  @client.paging.get_multiple_pages_failure_uri()}.to raise_exception(MsRest::HttpOperationError)
  end

  it 'should get multiple pages failure URI - lazy' do
    page = @client.paging.get_multiple_pages_failure_uri_as_lazy
    expect(page.is_a? PagingModule::Models::ProductResult)
    expect(page.next_link).not_to be_nil

    expect { page.get_next_page  }.to raise_exception(MsRest::HttpOperationError)
  end
end
