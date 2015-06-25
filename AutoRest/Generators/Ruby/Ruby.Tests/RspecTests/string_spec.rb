require_relative 'String/sdk_requirements'
include MyNamespace

describe String do
  before(:all) do
    @base_url = ENV['StubServerURI']
    client = MyNamespace::AutoRestSwaggerBATService.new(@base_url)
    @string_client = MyNamespace::String.new(client)
  end

  it 'should create test service' do
    expect{MyNamespace::AutoRestSwaggerBATService.new(@base_url)}.not_to raise_error
  end
  it 'should get null' do
    result = @string_client.get_null().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to be_nil
  end
  it 'should put null' do
    result = @string_client.put_null(nil).value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get empty' do
    result = @string_client.get_empty().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq('')
  end
  it 'should put empty' do
    result = @string_client.put_empty('').value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get mbcs' do
    result = @string_client.get_mbcs().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body.force_encoding('utf-8')).to eq('啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€')
  end
  it 'should put mbcs' do
    result = @string_client.put_mbcs('啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€').value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get whitespace' do
    result = @string_client.get_whitespace().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to eq('    Now is the time for all good men to come to the aid of their country    ')
  end
  it 'should put whitespace' do
    result = @string_client.put_whitespace('    Now is the time for all good men to come to the aid of their country    ').value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
  end
  it 'should get notProvided' do
    result = @string_client.get_not_provided().value!
    expect(result.response).to be_an_instance_of(Net::HTTPOK)
    expect(result.body).to be_nil
  end
end