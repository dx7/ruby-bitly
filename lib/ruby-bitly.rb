# -*- encoding: utf-8 -*-
require 'yaml'
require 'restclient'
require 'json'
require 'ostruct'

class Bitly < OpenStruct

  REST_API_URL = "http://api.bit.ly"
  ACTION_PATH = { :shorten => '/v3/shorten', :expand => '/v3/expand', :clicks => '/v3/clicks' }
  RestClient.proxy = ENV['http_proxy']

  class << self
    attr_accessor :login, :key

    # Old API:
    #
    # shorten(long_url, login = self.login, key = self.key)
    #
    # New API:
    #
    # shorten(options)
    #
    # Options can have:
    #
    # :long_url
    # :login
    # :api_key
    # :domain
    def shorten(long_url, login = self.login, key = self.key)
      if long_url.is_a?(Hash)
        options = long_url
        long_url = options[:long_url]
        login = options[:login] || self.login
        key = options[:api_key] || self.key
      else
        options = {}
      end

      params = { :longURL => long_url, :login => login, :apiKey => key }

      if options[:domain]
        params[:domain] = options[:domain]
      end

      response = JSON.parse RestClient.post(REST_API_URL + ACTION_PATH[:shorten], params)
      response.delete("data") if response["data"].empty?

      bitly = new response["data"]

      bitly.hash_path = response["data"]["hash"] if response["status_code"] == 200
      bitly.status_code = response["status_code"]
      bitly.status_txt = response["status_txt"]

      bitly
    end

    # Old API:
    #
    # expand(short_url, login = self.login, key = self.key)
    #
    # New API:
    #
    # expand(options)
    #
    # Options can have:
    #
    # :long_url
    # :login
    # :api_key
    def expand(short_url, login = self.login, key = self.key)
      if short_url.is_a?(Hash)
        options = short_url
        short_url = options[:short_url]
        login = options[:login] || self.login
        key = options[:api_key] || self.key
      else
        options = {}
      end

      response = JSON.parse RestClient.post(REST_API_URL + ACTION_PATH[:expand], { :shortURL => short_url, :login => login, :apiKey => key })

      bitly = new(response["data"]["expand"].first)
      bitly.status_code = response["status_code"]
      bitly.status_txt = response["status_txt"]
      bitly.long_url = bitly.error if bitly.error

      bitly
    end

    # Old API:
    #
    # get_clicks(short_url, login = self.login, key = self.key)
    #
    # New API:
    #
    # get_clicks(options)
    #
    # Options can have:
    #
    # :long_url
    # :login
    # :api_key
    def get_clicks(short_url, login = self.login, key = self.key)
      if short_url.is_a?(Hash)
        options = short_url
        short_url = options[:short_url]
        login = options[:login] || self.login
        key = options[:api_key] || self.key
      else
        options = {}
      end

      response = JSON.parse RestClient.get("#{REST_API_URL}#{ACTION_PATH[:clicks]}?login=#{login}&apiKey=#{key}&shortUrl=#{short_url}")

      bitly = new(response["data"]["clicks"].first)
      bitly.status_code = response["status_code"]
      bitly.status_txt = response["status_txt"]

      bitly
    end
  end
end
