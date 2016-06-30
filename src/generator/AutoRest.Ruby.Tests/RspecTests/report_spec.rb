# encoding: utf-8

$: << 'RspecTests/Generated/report'

require 'generated/report'

include ReportModule

describe AutoRestReportService do
  before(:all) do
    @base_url = ENV['StubServerURI']

    dummyToken = 'dummy12321343423'
    @credentials = MsRest::TokenCredentials.new('Bearer', dummyToken)
    @client = AutoRestReportService.new(@credentials, @base_url)
  end

  it 'should send a report' do
    result = @client.get_report()
    count_of_methods = 0
    count_of_calls = 0
    result.each do |key, value|
      count_of_methods += 1
      if value.to_i > 0
        count_of_calls += 1
      end
    end
    puts "Test Coverage is #{count_of_calls}/#{count_of_methods}"
    expect(count_of_calls/count_of_methods.to_f > 0.90).to be_truthy
  end
end
