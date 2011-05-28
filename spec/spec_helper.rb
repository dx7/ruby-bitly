# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-bitly'
require 'rspec'
require 'rspec/autorun'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.ignore_localhost = true
  c.stub_with :webmock # or :fakeweb
  c.default_cassette_options = { :record => :once }
end
