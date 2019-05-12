$:.push File.expand_path("../lib", __FILE__)
require "ruby-bitly/version"

Gem::Specification.new do |s|
  s.name                  = "ruby-bitly"
  s.version               = BitlyGem::VERSION
  s.authors               = ["dx7"]
  s.email                 = ["dx7@pm.me"]
  s.homepage              = "http://github.com/dx7/ruby-bitly"
  s.summary               = %q{A simple bit.ly ruby client to shorten URLs, expand or get number of clicks on a bitlink}
  s.description           = %q{A simple bit.ly ruby client to shorten URLs, expand or get number of clicks on a bitlink.}
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {spec,fixtures,gemfiles}/*`.split("\n")
  s.executables           = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths         = ["lib"]
  s.licenses              = ['MIT']
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency('rest-client', '~> 2.0')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('vcr')
  s.add_development_dependency('webmock')
  s.add_development_dependency('public_suffix', '< 3') # it is a webmock dependency. it is neccessary to run tests on ruby 2.0
  s.add_development_dependency('wwtd')
end
