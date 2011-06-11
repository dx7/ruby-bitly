# -*- encoding: utf-8 -*-
require 'yaml'
require 'restclient'
require 'json'
require 'ostruct'

class Bitly < OpenStruct

  VERSION = '1.0.5.beta2'
  REST_API_URL = "http://api.bit.ly"
  ACTION_PATH = { :shorten => '/v3/shorten', :expand => '/v3/expand', :clicks => '/v3/clicks' }

  def Bitly.shorten(new_long_url, login, key)
    response = JSON.parse RestClient.post(REST_API_URL + ACTION_PATH[:shorten], { :longURL => new_long_url, :login => login, :apiKey => key })

    bitly = Bitly.new response["data"]

    bitly.hash_path = response["data"]["hash"] if response["status_code"] == 200
    bitly.status_code = response["status_code"]
    bitly.status_txt = response["status_txt"]

    bitly
  end

  def Bitly.expand(new_short_url, login, key)
    response = JSON.parse RestClient.post(REST_API_URL + ACTION_PATH[:expand], { :shortURL => new_short_url, :login => login, :apiKey => key })

    bitly = Bitly.new(response["data"]["expand"].first)
    bitly.status_code = response["status_code"]
    bitly.status_txt = response["status_txt"]
    bitly.long_url = bitly.error if bitly.error

    bitly
  end

  def Bitly.get_clicks(new_short_url, login, key)
    response = JSON.parse RestClient.get("#{REST_API_URL}#{ACTION_PATH[:clicks]}?login=#{login}&apiKey=#{key}&shortUrl=#{new_short_url}")

    bitly = Bitly.new(response["data"]["clicks"].first)
    bitly.status_code = response["status_code"]
    bitly.status_txt = response["status_txt"]

    bitly
  end
end
