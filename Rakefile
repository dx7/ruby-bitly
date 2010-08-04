require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ruby-bitly"
    gem.summary = %Q{This is a simple bit.ly ruby client}
    gem.description = %Q{This is a simple bit.ly ruby client}
    gem.email = "rafaeldx7@gmail.com"
    gem.homepage = "http://github.com/rafaeldx7/ruby-bitly"
    gem.authors = ["rafaeldx7"]
    gem.add_runtime_dependency "rest-client", "1.5.1"
    gem.add_runtime_dependency "json_pure", "1.4.3"
    gem.add_development_dependency "rake", "0.8.7"
    gem.add_development_dependency "rspec", "1.3.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : "0.0.0"

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-bitly #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
