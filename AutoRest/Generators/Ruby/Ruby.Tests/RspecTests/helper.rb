# encoding: utf-8

RSpec::Matchers.define :be_equal_datetimes do |expected|
  match do |actual|
      (expected == nil && actual == nil) ||
      ((expected != nil && actual != nil) && (expected.iso8601 == actual.iso8601))
  end
  failure_message do |actual|
    "expected datetime #{actual.inspect} to be equal to #{expected.inspect}"
  end
  failure_message_when_negated do |actual|
    "expected datetime #{actual.inspect} not to be equal to #{expected.inspect}"
  end
  description do
    'be equal datetimes'
  end
end

RSpec::Matchers.define :be_equal_objects do |expected|
  match do |actual|
      (expected == nil && actual == nil) ||
          ((expected != nil && actual != nil) &&
              (expected.string == actual.string) && (expected.integer == actual.integer))
  end
  failure_message do |actual|
    "expected array of object #{actual.inspect} to be equal to #{expected.inspect}"
  end
  failure_message_when_negated do |actual|
    "expected array of object #{actual.inspect} not to be equal to #{expected.inspect}"
  end
  description do
    'be equal objects'
  end
end

RSpec::Matchers.define :be_equal_dict do |expected|
  match do |actual|
    (expected == nil && actual == nil) ||
        ((expected != nil && actual != nil) &&
            expected.keys.all? {|k| actual.has_key?(k) && (actual[k] == expected[k])})
  end
  failure_message do |actual|
    "expected dictionary of object #{actual.inspect} to be equal to #{expected.inspect}"
  end
  failure_message_when_negated do |actual|
    "expected dictionary of object #{actual.inspect} not to be equal to #{expected.inspect}"
  end
  description do
    'be equal dictionary'
  end
end

RSpec::Matchers.define :raise_exception_with_code do |http_error_code|
  match do |block|
    begin
      block.call
    rescue MsRest::HttpOperationError => exception
      exception.response.status == http_error_code
    end
  end
  def supports_block_expectations?
    true
  end
  failure_message do |actual|
    "Expected method to fail with code #{exception_class}"
  end
  failure_message_when_negated do |actual|
    "Expected method not to fail with code #{exception_class}"
  end
end