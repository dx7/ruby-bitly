$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'byebug'
require 'ruby-bitly'
require 'rspec'
require 'vcr'

RSpec::RUBY_BITLY_LOGIN = ENV['RUBY_BITLY_LOGIN'] || 'my-login'
RSpec::RUBY_BITLY_APIKEY = ENV['RUBY_BITLY_APIKEY'] || 'my-api-key'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.ignore_localhost = true
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once, :match_requests_on => [:method, :uri, :host, :path, :body, :query] }
  c.filter_sensitive_data('my-login') { RSpec::RUBY_BITLY_LOGIN }
  c.filter_sensitive_data('my-api-key') { RSpec::RUBY_BITLY_APIKEY }
end
