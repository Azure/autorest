# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ms_rest/version'

Gem::Specification.new do |spec|
  spec.name          = "ms_rest"
  spec.version       = MsRest::VERSION
  spec.authors       = [""]
  spec.email         = [""]

  spec.summary       = %q{Azure Client Library for Ruby.}
  spec.description   = %q{Azure Client Library for Ruby.}
  spec.homepage      = "https://rubygems.org/gems/azure"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "json", "~> 1.8.3"
  spec.add_runtime_dependency "timeliness", "~> 0.3.7"
  spec.add_runtime_dependency "concurrent-ruby-ext", "~> 0.8.0"
  spec.add_runtime_dependency "faraday", "~> 0.9.1"
  spec.add_runtime_dependency "faraday-cookie_jar", "~> 0.0.6"
end
