# encoding: utf-8

$: << 'RspecTests/Generated/string'

require 'generated/body_string'

include StringModule

describe String do
  before(:all) do
    @base_url = ENV['StubServerURI']

	dummyToken = 'dummy12321343423'
	@credentials = MsRest::TokenCredentials.new(dummyToken)

    client = AutoRestSwaggerBATService.new(@credentials, @base_url)
    @string_client = StringModule::String.new(client)

    @enum_client = StringModule::Enum.new(client)
  end

  it 'should create test service' do
    expect { AutoRestSwaggerBATService.new(@credentials, @base_url) }.not_to raise_error
  end

  it 'should get null' do
    result = @string_client.get_null_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end
  it 'should put null' do
    result = @string_client.put_null_async(nil).value!
    expect(result.response.status).to eq(200)
  end
  it 'should get empty' do
    result = @string_client.get_empty_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq('')
  end
  it 'should put empty' do
    result = @string_client.put_empty_async('').value!
    expect(result.response.status).to eq(200)
  end
  it 'should get mbcs' do
    result = @string_client.get_mbcs_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body.force_encoding('utf-8')).to eq('啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€')
  end
  it 'should put mbcs' do
    result = @string_client.put_mbcs_async('啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€').value!
    expect(result.response.status).to eq(200)
  end
  it 'should get whitespace' do
    result = @string_client.get_whitespace_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq('    Now is the time for all good men to come to the aid of their country    ')
  end
  it 'should put whitespace' do
    result = @string_client.put_whitespace_async('    Now is the time for all good men to come to the aid of their country    ').value!
    expect(result.response.status).to eq(200)
  end
  it 'should get notProvided' do
    result = @string_client.get_not_provided_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to be_nil
  end
  it 'should support valid enum valid value' do
    result = @enum_client.get_not_expandable_async().value!
    expect(result.response.status).to eq(200)
    expect(result.response.body).to include('red color')
  end
  it 'should correctly handle invalid values for enum' do
    expect { @enum_client.put_not_expandable_async('orange color').value! }.to raise_error(MsRest::ValidationError)
  end
  it 'should get non-expandable enum' do
    result = @enum_client.get_not_expandable_async().value!
    expect(result.response.status).to eq(200)
    expect(result.body).to eq(StringModule::Models::Colors::Redcolor)
  end
  it 'should put non-expandable enum' do
    result = @enum_client.put_not_expandable_async(StringModule::Models::Colors::Redcolor).value!
    expect(result.response.status).to eq(200)
  end
end