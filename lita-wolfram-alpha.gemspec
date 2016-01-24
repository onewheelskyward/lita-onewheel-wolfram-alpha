Gem::Specification.new do |spec|
  spec.name          = 'lita-onewheel-wolfram-alpha'
  spec.version       = '0.0.0'
  spec.authors       = ['Andrew Kreps']
  spec.email         = ['andrew.kreps@gmail.com']
  spec.description   = %q{Lita interface to Wolfram Alpha.}
  spec.summary       = %q{Summarize THIS!}
  spec.homepage      = 'https://github.com/onewheelskyward/lita-onewheel-wolfram-alpha'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler'}

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '~> 4.7'
  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
end
