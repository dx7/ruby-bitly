# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby-bitly/version"

Gem::Specification.new do |s|
  s.name          = "ruby-bitly"
  s.version       = BitlyGem::VERSION
  s.authors       = ["dx7"]
  s.email         = ["dx7@protonmail.ch"]
  s.homepage      = "http://github.com/dx7/ruby-bitly"
  s.summary       = %q{A simple bit.ly ruby client}
  s.description   = %q{A simple bit.ly ruby client}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('rest-client', '~> 2.0')
  s.add_development_dependency('byebug')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.13')
  s.add_development_dependency('vcr', '~> 3.0')
  s.add_development_dependency('webmock', '~> 2.1')
end
