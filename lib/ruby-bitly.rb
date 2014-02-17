# -*- encoding: utf-8 -*-
require 'yaml'
require 'restclient'
require 'json'
require 'ostruct'

class Bitly < OpenStruct

  REST_API_URL = "http://api.bit.ly"
  ACTION_PATH = { :shorten => '/v3/shorten', :expand => '/v3/expand', :clicks => '/v3/clicks' }

  class << self
    attr_accessor :login, :key

    # Old API:
    #
    # shorten(new_long_url, login = self.login, key = self.key)
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
    def shorten(new_long_url, login = self.login, key = self.key)
      if new_long_url.is_a?(Hash)
        options = new_long_url
        new_long_url = options[:long_url]
        login = options[:login] || self.login
        key = options[:api_key] || self.key
      else
        options = {}
      end
      params = { :longURL => new_long_url, :login => login, :apiKey => key }
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

    def expand(new_short_url, login = self.login, key = self.key)
      response = JSON.parse RestClient.post(REST_API_URL + ACTION_PATH[:expand], { :shortURL => new_short_url, :login => login, :apiKey => key })

      bitly = new(response["data"]["expand"].first)
      bitly.status_code = response["status_code"]
      bitly.status_txt = response["status_txt"]
      bitly.long_url = bitly.error if bitly.error

      bitly
    end

    def get_clicks(new_short_url, login = self.login, key = self.key)
      response = JSON.parse RestClient.get("#{REST_API_URL}#{ACTION_PATH[:clicks]}?login=#{login}&apiKey=#{key}&shortUrl=#{new_short_url}")

      bitly = new(response["data"]["clicks"].first)
      bitly.status_code = response["status_code"]
      bitly.status_txt = response["status_txt"]

      bitly
    end
  end
end
