# encoding: utf-8

$: << 'RspecTests/Generated/parameter_grouping'

require 'rspec'
require 'generated/azure_parameter_grouping'

include ParameterGroupingModule
include ParameterGroupingModule::Models

describe 'ParameterGrouping' do
  before(:all) do
    @base_url = ENV['StubServerURI']
    dummyToken = 'dummy123@query343423'
    @credentials = MsRest::TokenCredentials.new(dummyToken)
    @client = AutoRestParameterGroupingTestService.new(@credentials, @base_url)

    @body = 1234
    @header = 'header'
    @query = 21
    @path = 'path'
  end

  it 'should accept valid required parameters' do
    required_parameters = ParameterGroupingPostRequiredParameters.new
    required_parameters.body = @body
    required_parameters.custom_header = @header
    required_parameters.query = @query
    required_parameters.path = @path

    result = @client.parameter_grouping.post_required_async(required_parameters).value!

    expect(result.response.status).to eq(200)
  end

  it 'should accept required parameters but null optional parameters' do
    required_parameters = ParameterGroupingPostRequiredParameters.new
    required_parameters.body = @body
    required_parameters.path = @path

    result = @client.parameter_grouping.post_required_async(required_parameters).value!

    expect(result.response.status).to eq(200)
  end

  it 'should reject required parameters with missing required property' do
    required_parameters = ParameterGroupingPostRequiredParameters.new
    required_parameters.path = @path

    expect { @client.parameter_grouping.post_required_async(required_parameters).value! }.to raise_error(MsRest::ValidationError)
  end

  it 'should reject null required parameters' do
    required_parameters = ParameterGroupingPostRequiredParameters.new
    required_parameters.path = nil

    expect { @client.parameter_grouping.post_required_async(required_parameters).value! }.to raise_error(MsRest::ValidationError)
  end

  it 'should accept valid optional parameters' do
    optional_parameters = ParameterGroupingPostOptionalParameters.new
    optional_parameters.custom_header = @header
    optional_parameters.query = @query

    result = @client.parameter_grouping.post_optional_async(optional_parameters).value!
    expect(result.response.status).to eq(200)
  end

  it 'should accept null optional parameters' do
    result = @client.parameter_grouping.post_optional_async(nil).value!
    expect(result.response.status).to eq(200)
  end

  it 'should allow multiple parameter groups' do
    first_parameter_group = FirstParameterGroup.new
    second_parameter_group = ParameterGroupingPostMultiParamGroupsSecondParamGroup.new

    first_parameter_group.header_one = @header
    first_parameter_group.query_one = @query

    second_parameter_group.header_two = 'header2'
    second_parameter_group.query_two = 42

    result = @client.parameter_grouping.post_multi_param_groups_async(first_parameter_group, second_parameter_group).value!
    expect(result.response.status).to eq(200)
  end

  it 'should allow multiple parameter groups with some defaults omitted' do
    first_parameter_group = FirstParameterGroup.new
    second_parameter_group = ParameterGroupingPostMultiParamGroupsSecondParamGroup.new

    first_parameter_group.header_one = @header

    second_parameter_group.query_two = 42

    result = @client.parameter_grouping.post_multi_param_groups_async(first_parameter_group, second_parameter_group).value!
    expect(result.response.status).to eq(200)
  end

  # This test has nothing to do with sharing of the FirstParameterGroup. It's included for test coverage
  it 'should allow parameter group objects to be shared between operations' do
    first_parameter_group = FirstParameterGroup.new

    first_parameter_group.header_one = @header
    first_parameter_group.query_one = 42

    result = @client.parameter_grouping.post_shared_parameter_group_object_async(first_parameter_group).value!
    expect(result.response.status).to eq(200)
  end
end