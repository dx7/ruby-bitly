require 'rubygems'
require 'yaml'
require 'restclient'
require 'json'

class Bitly
  
  attr_reader :response, :status_code, :status_txt, :new_hash, :global_hash, :user_hash, :hash
  attr_accessor :long_url, :short_url
  
  PERSONAL_FILE_PATH = "#{ENV['HOME']}/.bitly"
  REST_API_URL = "http://api.bit.ly"
  ACTION_PATH = { :shorten => '/v3/shorten', :expand => '/v3/expand' }
  
  def Bitly.load_personal_data
    personal_data = YAML.load(File.read(PERSONAL_FILE_PATH))
    
    if personal_data
      @@login = personal_data["login"]
      @@key = personal_data["key"]
      personal_data
    end
  end
  
  def shorten
    unless @response
      @response = Bitly.shorten(@long_url)
    
      @status_code = @response["status_code"]
      @status_txt = @response["status_txt"]
      @new_hash = @response["data"]["new_hash"]
      @global_hash = @response["data"]["global_hash"]
      @hash = @response["data"]["hash"]
      @bitly = short_url = @response["data"]["url"]
    end

    @bitly
  end
  
  def expand
    @response = Bitly.expand(@short_url)
    @long_url = @response["data"]["expand"].first["long_url"]
    @global_hash = @response["data"]["expand"].first["global_hash"]
    @user_hash = @response["data"]["expand"].first["user_hash"]
    @status_code = @response["status_code"]
    @status_txt = @response["status_txt"]
    
    @long_url
  end
  
  def Bitly.shorten(new_long_url)
    Bitly.load_personal_data
    response = RestClient.post(REST_API_URL + ACTION_PATH[:shorten], { :longURL => new_long_url, :login => @@login, :apiKey => @@key })
    JSON.parse(response)
  end
  
  def Bitly.expand(new_short_url)
    response = RestClient.post(REST_API_URL + ACTION_PATH[:expand], { :shortURL => new_short_url, :login => @@login, :apiKey => @@key })
    JSON.parse(response)
  end
  
  alias :bitly :shorten
end