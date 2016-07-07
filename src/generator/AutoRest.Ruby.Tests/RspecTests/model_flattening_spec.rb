# encoding: utf-8

$: << 'RspecTests/Generated/model_flattening'

require 'securerandom'
require 'generated/model_flattening'

include ModelFlatteningModule
include ModelFlatteningModule::Models

describe 'Resource Flattening Operations' do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)

    @client = AutoRestResourceFlatteningTestService.new(@credentials, @base_url)

    @product1 = FlattenedProduct.new
    @product1.location = "West US"
    @product1.tags = {
        "tag1" => "value1",
        "tag2" => "value3"
    }
    @product1.pname = "Product1"
    @product1.flattened_product_type = "Flat"

    product2 = FlattenedProduct.new
    product2.location = "Building 44"
    product2.pname = "Product2"
    product2.flattened_product_type = "Flat"

    @dict_resource = {
        "Resource1" => @product1,
        "Resource2" => product2
    }

    @array_resource = [@product1, product2]
  end

  it 'should get external resource as an array' do
    result = @client.get_array_async().value!
    
    expect(result.body.count).to eq(3)
    result.body.each do |flatten_product|
      expect(flatten_product).to be_instance_of(FlattenedProduct)
    end

    # Resource 1
    expect(result.body[0].id).to eq("1")
    expect(result.body[0].name).to eq("Resource1")
    expect(result.body[0].location).to eq("Building 44")
    expect(result.body[0].type).to eq("Microsoft.Web/sites")
    expect(result.body[0].pname).to eq("Product1")
    expect(result.body[0].provisioning_state).to eq("Succeeded")
    expect(result.body[0].provisioning_state_values).to eq("OK")
    expect(result.body[0].tags["tag1"]).to eq("value1")
    expect(result.body[0].tags["tag2"]).to eq("value3")

    # Resource 2
    expect(result.body[1].id).to eq("2")
    expect(result.body[1].location).to eq("Building 44")
    expect(result.body[1].name).to eq("Resource2")

    # Resource 3
    expect(result.body[2].id).to eq("3")
    expect(result.body[2].name).to eq("Resource3")
  end

  it 'should put external resource as an array' do
    result = @client.put_array_async(@array_resource).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get external resource as a dictionary' do
    result = @client.get_dictionary_async().value!
    expect(result.body.count).to eq(3)

    result.body do |_, value|
      expect(value).to be_instance_of(FlattenedProduct)
    end

    # Resource 1
    expect(result.body["Product1"].id).to eq("1")
    expect(result.body["Product1"].location).to eq("Building 44")
    expect(result.body["Product1"].name).to eq("Resource1")
    expect(result.body["Product1"].type).to eq("Microsoft.Web/sites")
    expect(result.body["Product1"].provisioning_state_values).to eq("OK")
    expect(result.body["Product1"].pname).to eq("Product1")
    expect(result.body["Product1"].provisioning_state).to eq("Succeeded")
    expect(result.body["Product1"].tags["tag1"]).to eq("value1")
    expect(result.body["Product1"].tags["tag2"]).to eq("value3")

    # Resource 2
    expect(result.body["Product2"].id).to eq("2")
    expect(result.body["Product2"].location).to eq("Building 44")
    expect(result.body["Product2"].name).to eq("Resource2")

    # Resource 3
    expect(result.body["Product3"].id).to eq("3")
    expect(result.body["Product3"].name).to eq("Resource3")
  end

  it 'should put external resource as a dictionary' do
    result = @client.put_dictionary_async(@dict_resource).value!
    expect(result.response.status).to eq(200)
  end

  it 'should get external resource as a complex type' do
    result = @client.get_resource_collection_async().value!

    # Resource 1
    expect(result.body.dictionaryofresources.count).to eq(3)
    expect(result.body.dictionaryofresources["Product1"].id).to eq("1")
    expect(result.body.dictionaryofresources["Product1"].location).to eq("Building 44")
    expect(result.body.dictionaryofresources["Product1"].name).to eq("Resource1")
    expect(result.body.dictionaryofresources["Product1"].type).to eq("Microsoft.Web/sites")
    expect(result.body.dictionaryofresources["Product1"].tags["tag1"]).to eq("value1")
    expect(result.body.dictionaryofresources["Product1"].tags["tag2"]).to eq("value3")
    expect(result.body.dictionaryofresources["Product1"].provisioning_state_values).to eq("OK")
    expect(result.body.dictionaryofresources["Product1"].pname).to eq("Product1")
    expect(result.body.dictionaryofresources["Product1"].provisioning_state).to eq("Succeeded")

    # Resource 2
    expect(result.body.dictionaryofresources["Product2"].id).to eq("2")
    expect(result.body.dictionaryofresources["Product2"].location).to eq("Building 44")
    expect(result.body.dictionaryofresources["Product2"].name).to eq("Resource2")

    # Resource 3
    expect(result.body.dictionaryofresources["Product3"].id).to eq("3")
    expect(result.body.dictionaryofresources["Product3"].name).to eq("Resource3")
    expect(result.body.arrayofresources.count).to eq(3)

    # Resource 1
    expect(result.body.arrayofresources[0].id).to eq("4")
    expect(result.body.arrayofresources[0].name).to eq("Resource4")
    expect(result.body.arrayofresources[0].location).to eq("Building 44")
    expect(result.body.arrayofresources[0].type).to eq("Microsoft.Web/sites")
    expect(result.body.arrayofresources[0].provisioning_state_values).to eq("OK")
    expect(result.body.arrayofresources[0].pname).to eq("Product4")
    expect(result.body.arrayofresources[0].provisioning_state).to eq("Succeeded")
    expect(result.body.arrayofresources[0].tags["tag1"]).to eq("value1")
    expect(result.body.arrayofresources[0].tags["tag2"]).to eq("value3")

    # Resource 2
    expect(result.body.arrayofresources[1].id).to eq("5")
    expect(result.body.arrayofresources[1].location).to eq("Building 44")
    expect(result.body.arrayofresources[1].name).to eq("Resource5")

    # Resource 3
    expect(result.body.arrayofresources[2].id).to eq("6")
    expect(result.body.arrayofresources[2].name).to eq("Resource6")
  end

  it 'should put external resource as a complex type' do
    complex_resource = ResourceCollection.new

    product2 = FlattenedProduct.new
    product2.location = "East US"
    product2.pname = "Product2"
    product2.flattened_product_type = "Flat"

    product = FlattenedProduct.new
    product.location = "India"
    product.pname = "Azure"
    product.flattened_product_type = "Flat"

    complex_resource.dictionaryofresources = @dict_resource
    complex_resource.arrayofresources = [@product1, product2]
    complex_resource.productresource = product
    result = @client.put_resource_collection_async(complex_resource).value!
    expect(result.response.status).to eq(200)
  end

  it 'should put simple product to flatten' do
    simple_product = SimpleProduct.new
    simple_product.product_id = '123'
    simple_product.description = 'product description'
    simple_product.max_product_display_name = 'max name'
    simple_product.odatavalue = 'http://foo'
    simple_product.generic_value = 'https://generic'

    result = @client.put_simple_product_async(simple_product).value!
    expect(result.response.status).to eq(200)
  end

  it 'should post simple product with param flattening' do
    result = @client.post_flattened_simple_product_async('123', 'max name', 'product description', nil, 'http://foo').value!
    expect(result.response.status).to eq(200)

    simple_product = result.body
    expect(simple_product).to be_instance_of(SimpleProduct)
    expect(simple_product.product_id).to eq('123')
    expect(simple_product.max_product_display_name).to eq('max name')
    expect(simple_product.description).to eq('product description')
    expect(simple_product.odatavalue).to eq('http://foo')
    expect(simple_product.capacity).to eq('Large')
    expect(simple_product.generic_value).to be_nil
  end

  it 'should put flattened and grouped product' do
    param_group = FlattenParameterGroup.new
    param_group.product_id = '123'
    param_group.description = 'product description'
    param_group.max_product_display_name = 'max name'
    param_group.odatavalue = 'http://foo'
    param_group.name = 'groupproduct'

    result = @client.put_simple_product_with_grouping_async(param_group).value!
    expect(result.response.status).to eq(200)

    simple_product = result.body
    expect(simple_product).to be_instance_of(SimpleProduct)
    expect(simple_product.product_id).to eq('123')
    expect(simple_product.max_product_display_name).to eq('max name')
    expect(simple_product.description).to eq('product description')
    expect(simple_product.odatavalue).to eq('http://foo')
    expect(simple_product.capacity).to eq('Large')
    expect(simple_product.generic_value).to be_nil
  end
end