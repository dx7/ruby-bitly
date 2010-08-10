# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-bitly}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["rafaeldx7"]
  s.date = %q{2010-08-10}
  s.default_executable = %q{bitly}
  s.description = %q{This is a simple bit.ly ruby client}
  s.email = %q{rafaeldx7@gmail.com}
  s.executables = ["bitly"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGELOG",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/bitly",
     "lib/readme.rb",
     "lib/ruby-bitly.rb",
     "ruby-bitly.gemspec",
     "spec/ruby-bitly_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/rafaeldx7/ruby-bitly}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{This is a simple bit.ly ruby client}
  s.test_files = [
    "spec/ruby-bitly_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, ["= 1.6.0"])
      s.add_runtime_dependency(%q<json_pure>, ["= 1.4.3"])
      s.add_development_dependency(%q<rake>, ["= 0.8.7"])
      s.add_development_dependency(%q<rspec>, ["= 1.3.0"])
    else
      s.add_dependency(%q<rest-client>, ["= 1.6.0"])
      s.add_dependency(%q<json_pure>, ["= 1.4.3"])
      s.add_dependency(%q<rake>, ["= 0.8.7"])
      s.add_dependency(%q<rspec>, ["= 1.3.0"])
    end
  else
    s.add_dependency(%q<rest-client>, ["= 1.6.0"])
    s.add_dependency(%q<json_pure>, ["= 1.4.3"])
    s.add_dependency(%q<rake>, ["= 0.8.7"])
    s.add_dependency(%q<rspec>, ["= 1.3.0"])
  end
end

