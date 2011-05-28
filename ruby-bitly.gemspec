# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = "ruby-bitly"
  s.version       = "0.1.4"
  s.authors       = ["rafaeldx7"]
  s.email         = ["rafaeldx7@gmail.com"]
  s.homepage      = "http://github.com/rafaeldx7/ruby-bitly"
  s.summary       = %q{A simple bit.ly ruby client}
  s.description   = %q{A simple bit.ly ruby client}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
