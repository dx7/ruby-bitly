require 'rubygems'
require 'yaml'
require 'restclient'
require 'json'

class Bitly
  
  attr_reader :response, :status_code, :status_txt, :new_hash, :global_hash, :user_hash, :hash, :response, :long_url, :short_url, :global_clicks, :user_clicks
  
  PERSONAL_FILE_PATH = "#{ENV['HOME']}/.bitly"
  REST_API_URL = "http://api.bit.ly"
  ACTION_PATH = { :shorten => '/v3/shorten', :expand => '/v3/expand', :clicks => '/v3/clicks' }
  
  def initialize
    @read_only = false
  end
  
  def read_only?
    @read_only
  end
  
  def long_url=(url)
    @long_url = url unless read_only?
  end

  def short_url=(url)
    @short_url = url unless read_only?
  end
  
  def Bitly.load_personal_data
    personal_data = YAML.load(File.read(PERSONAL_FILE_PATH))
    
    if personal_data
      @@login = personal_data["login"]
      @@key = personal_data["key"]
      personal_data
    end
  end
  
  def read_only_now!
    @read_only = true
  end
  
  def shorten
    unless read_only?
      @response = Bitly.post_shorten(@long_url)
    
      @status_code = @response["status_code"]
      @status_txt = @response["status_txt"]
      @long_url = @response["data"]["long_url"]
      @new_hash = @response["data"]["new_hash"]
      @global_hash = @response["data"]["global_hash"]
      @hash = @response["data"]["hash"]
      @short_url = @response["data"]["url"]
      
      read_only_now!
    end
  end
  
  def expand
    @response = Bitly.post_expand(@short_url)
    
    @long_url = @response["data"]["expand"].first["long_url"]
    @global_hash = @response["data"]["expand"].first["global_hash"]
    @user_hash = @response["data"]["expand"].first["user_hash"]
    @status_code = @response["status_code"]
    @status_txt = @response["status_txt"]

    read_only_now!
  end
  
  def clicks
    @response = Bitly.get_clicks(@short_url)
    
    @global_clicks = @response["data"]["clicks"].first["global_clicks"]
    @user_clicks = @response["data"]["clicks"].first["user_clicks"]
    @global_hash = @response["data"]["clicks"].first["global_hash"]
    @user_hash = @response["data"]["clicks"].first["user_hash"]
    @status_code = @response["status_code"]
    @status_txt = @response["status_txt"]

    read_only_now!
  end
  
  def Bitly.request
    Bitly.load_personal_data
    
    response = yield
    
    JSON.parse(response)
  end
  
  def Bitly.post_shorten(new_long_url)
    Bitly.request do
      RestClient.post(REST_API_URL + ACTION_PATH[:shorten], { :longURL => new_long_url, :login => @@login, :apiKey => @@key })
    end
  end
  
  def Bitly.post_expand(new_short_url)
    Bitly.request do
      RestClient.post(REST_API_URL + ACTION_PATH[:expand], { :shortURL => new_short_url, :login => @@login, :apiKey => @@key })
    end
  end
  
  def Bitly.get_clicks(new_short_url)
    Bitly.request do
      RestClient.get("#{REST_API_URL}#{ACTION_PATH[:clicks]}?login=#{@@login}&apiKey=#{@@key}&shortUrl=#{new_short_url}")
      # RestClient.get(REST_API_URL + ACTION_PATH[:clicks], { :login => @@login, :apiKey => @@key, :shortUrl => new_short_url })
    end
  end
    
  def Bitly.shorten(new_long_url)
    bitly = Bitly.new
    bitly.long_url = new_long_url
    bitly.shorten
    bitly
  end
  
  def Bitly.expand(new_short_url)
    bitly = Bitly.new
    bitly.short_url = new_short_url
    bitly.expand
    bitly
  end
  
  def Bitly.clicks(new_short_url)
    bitly = Bitly.new
    bitly.short_url = new_short_url
    bitly.clicks
    bitly
  end
end