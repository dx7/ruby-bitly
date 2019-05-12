require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'RubyBitly' do

  let(:login) { RSpec::RUBY_BITLY_LOGIN }
  let(:api_key) { RSpec::RUBY_BITLY_APIKEY }

  describe 'config' do
    it 'set variable login' do
      Bitly.config { |c| c.login = 'login-custom' }
      expect(Bitly.login).to eq('login-custom')
    end

    it 'set variables api_key' do
      Bitly.config { |c| c.api_key = 'key-custom' }
      expect(Bitly.api_key).to eq('key-custom')
    end

    it 'set variables use_ssl' do
      Bitly.config { |c| c.use_ssl = false }
      expect(Bitly.use_ssl).to be false
      Bitly.config { |c| c.use_ssl = true } # reset to default value
    end
  end

  describe 'shorten' do
    context 'using local config' do
      before do
        Bitly.config { |c| c.login = 'any login'; c.api_key = 'any api_key' }
      end

      it 'shorten long url using new API' do
        response = VCR.use_cassette('shorten_long_url') do
          Bitly.shorten(:long_url => 'http://google.com', :login => login, :api_key => api_key)
        end

        expect(response.success?).to eq(true)
        expect(response.error).to eq(nil)
        expect(response.new_hash?).to eq(false)
        expect(response.global_hash).not_to be_empty
        expect(response.user_hash.length).not_to eq(0)
        expect(response.short_url).to match(/^http:\/\/bit\.ly\/[A-Za-z0-9]*/)
      end

      it 'shorten long url with a preferred domain' do
        response = VCR.use_cassette('shorten_long_url_with_preferred_domain') do
          Bitly.shorten(:long_url => 'http://google.com', :domain => 'j.mp', :login => login, :api_key => api_key)
        end

        expect(response.success?).to eq(true)
        expect(response.error).to eq(nil)
        expect(response.error).to eq(nil)
        expect(response.new_hash?).to eq(false)
        expect(response.global_hash).not_to be_empty
        expect(response.user_hash.length).not_to eq(0)
        expect(response.short_url).to match(/^http:\/\/j\.mp\/[A-Za-z0-9]*/)
      end

      it 'shorten bitly url' do
        response = VCR.use_cassette('shorten_bitly_url') do
          Bitly.shorten(long_url: 'http://bit.ly/bcvNe5', login: login, api_key: api_key)
        end

        expect(response.success?).to eq(false)
        expect(response.error).to eq('ALREADY_A_BITLY_LINK')
      end

      it 'uses invalid login' do
        response = VCR.use_cassette('shorten_using_invalid_login') do
          Bitly.shorten(long_url: 'http://bit.ly/bcvNe5', login: login, api_key: api_key)
        end

        expect(response.success?).to eq(false)
        expect(response.error).to eq('INVALID_LOGIN')
      end
    end

    context 'using global config' do
      before do
        Bitly.config { |c| c.login = login; c.api_key = api_key }
      end

      it 'shorten long url using global config' do
        response = VCR.use_cassette('shorten_long_url') do
          Bitly.shorten(:long_url => 'http://google.com')
        end

        expect(response.success?).to eq(true)
        expect(response.new_hash?).to eq(false)
        expect(response.global_hash).not_to be_empty
        expect(response.user_hash.length).not_to eq(0)
        expect(response.short_url).to match(/^http:\/\/bit\.ly\/[A-Za-z0-9]*/)
      end
    end
  end

  describe 'expand' do
    context 'using local config' do
      before do
        Bitly.config { |c| c.login = 'any login'; c.api_key = 'any api_key' }
      end

      it 'expand a short url to its long url old API' do
        response = VCR.use_cassette('expand_a_short_url_to_it_long_url') do
          Bitly.expand(short_url: 'http://bit.ly/bcvNe5', login: login, api_key: api_key)
        end

        expect(response.success?).to eq(true)
        expect(response.long_url).to eq('http://google.com')
        expect(response.short_url).to eq('http://bit.ly/bcvNe5')
        expect(response.user_hash).to eq('bcvNe5')
      end

      it 'expand a short url to its long url' do
        response = VCR.use_cassette('expand_a_short_url_to_it_long_url') do
          Bitly.expand({ :short_url => 'http://bit.ly/bcvNe5', :login => login, :api_key => api_key })
        end

        expect(response.success?).to eq(true)
        expect(response.long_url).to eq('http://google.com')
        expect(response.short_url).to eq('http://bit.ly/bcvNe5')
        expect(response.user_hash).to eq('bcvNe5')
      end

      it 'expand a long url should result an error' do
        response = VCR.use_cassette('expand_a_long_url_should_result_an_error') do
          Bitly.expand(short_url: 'http://google.com', login: login, api_key: api_key)
        end

        expect(response.success?).to eq(true)
        expect(response.long_url).to eq('NOT_FOUND')
        expect(response.short_url).to eq('http://google.com')
      end
    end

    context 'using global config' do
      before do
        Bitly.config { |c| c.login = login; c.api_key = api_key }
      end

      it 'expand a short url to its long url using global config' do
        response = VCR.use_cassette('expand_a_short_url_to_it_long_url') do
          Bitly.expand({ :short_url => 'http://bit.ly/bcvNe5' })
        end

        expect(response.success?).to eq(true)
        expect(response.long_url).to eq('http://google.com')
        expect(response.short_url).to eq('http://bit.ly/bcvNe5')
        expect(response.user_hash).to eq('bcvNe5')
      end
    end
  end


  describe 'get clicks' do
    context 'using local config' do
      before do
        Bitly.config { |c| c.login = 'any login'; c.api_key = 'any api_key' }
      end

      it 'get clicks by short_url using options API' do
        bitly = VCR.use_cassette('get_clicks_by_short_url') do
          Bitly.get_clicks(:short_url => 'http://bit.ly/xlii42', :login => login, :api_key => api_key)
        end

        expect(bitly.success?).to eq(true)
        expect(bitly.global_clicks).to be_an Integer
        expect(bitly.user_clicks).to be_an Integer
        expect(bitly.short_url).to eq('http://bit.ly/xlii42')
        expect(bitly.global_hash).to eq('cunZEP')
        expect(bitly.user_hash).to eq('cT1Izu')
      end
    end

    context 'using global config' do
      before do
        Bitly.config { |c| c.login = login; c.api_key = api_key }
      end

      it 'get clicks by short_url using global config' do
        bitly = VCR.use_cassette('get_clicks_by_short_url') do
          Bitly.get_clicks(:short_url => 'http://bit.ly/xlii42')
        end

        expect(bitly.success?).to eq(true)
        expect(bitly.global_clicks).to be_an Integer
        expect(bitly.user_clicks).to be_an Integer
        expect(bitly.short_url).to eq('http://bit.ly/xlii42')
        expect(bitly.global_hash).to eq('cunZEP')
        expect(bitly.user_hash).to eq('cT1Izu')
      end
    end
  end

  describe 'proxy' do
    it 'uses http_proxy as default' do
      expect(RestClient.proxy).not_to eq('http://http-proxy.host.com:1234')

      ENV['http_proxy'] = 'http://http-proxy.host.com:1234'
      Object.send :remove_const, :Bitly
      load './lib/ruby-bitly.rb'

      expect(RestClient.proxy).to eq('http://http-proxy.host.com:1234')
    end

    it 'uses set proxy on configuration' do
      expect(RestClient.proxy).not_to eq('http://config-proxy.host.com:1234')

      ENV['http_proxy'] = 'http://http-proxy.host.com:1234'
      Object.send :remove_const, :Bitly
      load './lib/ruby-bitly.rb'
      Bitly.proxy = 'http://config-proxy.host.com:1234'

      expect(RestClient.proxy).to eq('http://config-proxy.host.com:1234')
    end
  end

  describe 'ssl' do
    it 'do not use ssl if it is disabled' do
      Bitly.use_ssl = false

      bitly = VCR.use_cassette('get_clicks_by_short_url_without_ssl') do
        Bitly.get_clicks(:short_url => 'http://bit.ly/xlii42', :login => login, :api_key => api_key)
      end

      expect(bitly.success?).to eq(true)
    end
  end
end
