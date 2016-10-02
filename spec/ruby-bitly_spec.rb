# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'byebug'

describe "RubyBitly" do

  before(:all) do
    @login = ENV['RUBY_BITLY_LOGIN'] || 'my-login'
    @key = ENV['RUBY_BITLY_APIKEY'] || 'my-api-key'
  end

  it "Shorten long url using old API" do
    response = VCR.use_cassette('shorten_long_url') do
      Bitly.shorten("http://google.com", @login, @key)
    end

    expect(response.status_txt).to eq("OK")
    expect(response.status_code).to eq(200)
    expect(response.new_hash).to eq(0)
    expect(response.global_hash).not_to be_empty
    expect(response.hash_path.length).not_to eq(0)
    expect(response.url).to match(/^http:\/\/bit\.ly\/[A-Za-z0-9]*/)
  end

  it 'Shorten long url using options API' do
    response = VCR.use_cassette('shorten_long_url') do
      Bitly.shorten(:long_url => "http://google.com", :login => @login, :api_key => @key)
    end

    expect(response.status_txt).to eq("OK")
    expect(response.status_code).to eq(200)
    expect(response.new_hash).to eq(0)
    expect(response.global_hash).not_to be_empty
    expect(response.hash_path.length).not_to eq(0)
    expect(response.url).to match(/^http:\/\/bit\.ly\/[A-Za-z0-9]*/)
  end

  it 'Shorten url with a preferred domain' do
    response = VCR.use_cassette('shorten_long_url_with_preferred_domain') do
      Bitly.shorten(:long_url => "http://google.com", :domain => 'j.mp',
        :login => @login, :api_key => @key)
    end

    expect(response.status_txt).to eq("OK")
    expect(response.status_code).to eq(200)
    expect(response.new_hash).to eq(0)
    expect(response.global_hash).not_to be_empty
    expect(response.hash_path.length).not_to eq(0)
    expect(response.url).to match(/^http:\/\/j\.mp\/[A-Za-z0-9]*/)
  end

  it "Shorten bitly url" do
    response = VCR.use_cassette('shorten_bitly_url') do
      Bitly.shorten("http://bit.ly/bcvNe5", @login, @key)
    end

    expect(response.status_txt).to eq("ALREADY_A_BITLY_LINK")
    expect(response.status_code).to eq(500)
  end

  it "Expand a short url to it long url using old API" do
    response = VCR.use_cassette('expand_a_short_url_to_it_long_url') do
      Bitly.expand("http://bit.ly/bcvNe5", @login, @key)
    end

    expect(response.status_txt).to eq("OK")
    expect(response.status_code).to eq(200)
    expect(response.long_url).to eq("http://google.com")
    expect(response.short_url).to eq("http://bit.ly/bcvNe5")
    expect(response.user_hash).to eq("bcvNe5")
  end

  it "Expand a short url to it long url using options API" do
    response = VCR.use_cassette('expand_a_short_url_to_it_long_url') do
      Bitly.expand({ :short_url => "http://bit.ly/bcvNe5", :login => @login, :api_key => @key })
    end

    expect(response.status_txt).to eq("OK")
    expect(response.status_code).to eq(200)
    expect(response.long_url).to eq("http://google.com")
    expect(response.short_url).to eq("http://bit.ly/bcvNe5")
    expect(response.user_hash).to eq("bcvNe5")
  end

  it "Expand a long url should result an error" do
    response = VCR.use_cassette('expand_a_long_url_should_result_an_error') do
      Bitly.expand("http://google.com", @login, @key)
    end

    expect(response.status_txt).to eq("OK")
    expect(response.status_code).to eq(200)
    expect(response.long_url).to eq("NOT_FOUND")
    expect(response.short_url).to eq("http://google.com")
  end


  it "Get clicks by short_url using old API" do
    bitly = VCR.use_cassette('get_clicks_by_short_url') do
      Bitly.get_clicks("http://bit.ly/xlii42", @login, @key)
    end

    expect(bitly.status_txt).to eq("OK")
    expect(bitly.status_code).to eq(200)
    expect(bitly.global_clicks).to be_an_instance_of Fixnum
    expect(bitly.user_clicks).to be_an_instance_of Fixnum
    expect(bitly.short_url).to eq("http://bit.ly/xlii42")
    expect(bitly.global_hash).to eq("cunZEP")
    expect(bitly.user_hash).to eq("cT1Izu")
  end

  it "Get clicks by short_url using options API" do
    bitly = VCR.use_cassette('get_clicks_by_short_url') do
      Bitly.get_clicks(:short_url => "http://bit.ly/xlii42", :login => @login, :api_key => @key)
    end

    expect(bitly.status_txt).to eq("OK")
    expect(bitly.status_code).to eq(200)
    expect(bitly.global_clicks).to be_an_instance_of Fixnum
    expect(bitly.user_clicks).to be_an_instance_of Fixnum
    expect(bitly.short_url).to eq("http://bit.ly/xlii42")
    expect(bitly.global_hash).to eq("cunZEP")
    expect(bitly.user_hash).to eq("cT1Izu")
  end
end
