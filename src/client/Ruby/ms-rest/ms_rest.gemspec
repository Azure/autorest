# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ms_rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'ms_rest'
  spec.version       = MsRest::VERSION
  spec.authors       = 'Microsoft Corporation'
  spec.email         = 'azsdkteam@microsoft.com'

  spec.summary       = %q{Azure Client Library for Ruby.}
  spec.description   = %q{Azure Client Library for Ruby.}
  spec.homepage      = 'https://github.com/Azure/autorest'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'

  spec.add_runtime_dependency 'json', '~> 1.7'
  spec.add_runtime_dependency 'timeliness', '~> 0.3'
  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'faraday', '~> 0.9'
end
