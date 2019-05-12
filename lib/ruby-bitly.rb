require 'yaml'
require 'rest-client'
require 'json'
require 'ostruct'
require 'ruby-bitly/version'

class Bitly < OpenStruct

  REST_API_URL = 'http://api.bitly.com'
  REST_API_URL_SSL = 'https://api-ssl.bitly.com'
  ACTION_PATH = { shorten: '/v3/shorten', expand: '/v3/expand', clicks: '/v3/clicks' }
  RestClient.proxy = ENV['http_proxy']

  class << self
    attr_accessor :login, :api_key
    attr_writer :use_ssl

    def use_ssl
      instance_variable_defined?(:@use_ssl) ? @use_ssl : true
    end

    def proxy=(addr)
      RestClient.proxy = addr
    end

    def proxy
      RestClient.proxy
    end

    def config
      yield self
    end

    # shorten(options)
    #
    # Options are:
    #
    # long_url
    # login
    # api_key
    # domain
    def shorten(options)
      options = ensure_options(options)
      options.select! { |k,_v| [:longURL, :domain, :login, :apiKey].include?(k) }

      response = JSON.parse RestClient.post(rest_api_url + ACTION_PATH[:shorten], options)
      response['data'] = {} if response['data'].empty?

      bitly = new({ 'success?' => response['status_code'].to_i == 200 })

      if bitly.success?
        bitly.send('new_hash?=', response['data']['new_hash'].to_i == 1)
        bitly.short_url = response['data']['url']
        bitly.long_url = response['data']['long_url']
        bitly.global_hash = response['data']['global_hash']
        bitly.user_hash = response['data']['hash']
      else
        bitly.error = response['status_txt'] unless bitly.success?
      end

      bitly
    end

    # expand(options)
    #
    # Options are:
    #
    # short_url
    # login
    # api_key
    def expand(options)
      options = ensure_options(options)
      options.select! { |k,_v| [:shortURL, :login, :apiKey].include?(k) }

      response = JSON.parse RestClient.post(rest_api_url + ACTION_PATH[:expand], options)

      bitly = new(response["data"]["expand"].first)
      bitly.send('success?=', response["status_code"] == 200)
      bitly.long_url = bitly.error if bitly.error

      bitly
    end

    # get_clicks(options)
    #
    # Options are:
    #
    # short_url
    # login
    # api_key
    def get_clicks(options)
      options = ensure_options(options)
      options.select! { |k,_v| [:shortURL, :login, :apiKey].include?(k) }
      options[:shortUrl] = options.delete(:shortURL)

      response = JSON.parse RestClient.get("#{rest_api_url}#{ACTION_PATH[:clicks]}", params: options)

      bitly = new(response["data"]["clicks"].first)
      bitly.send('success?=', response["status_code"] == 200)

      bitly
    end

    private

      def ensure_options(options)
        response = {}
        response[:shortURL] = options[:short_url]
        response[:longURL] = options[:long_url]
        response[:domain] = options[:domain]
        response[:login] = options[:login] || self.login
        response[:apiKey] = options[:api_key] || self.api_key
        response.reject { |_k,v| v.nil? }
      end

      def rest_api_url
        { true => REST_API_URL_SSL, false => REST_API_URL }[use_ssl]
      end
  end
end
