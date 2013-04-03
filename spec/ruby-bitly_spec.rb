# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyBitly" do

  before(:all) do
    @login = 'my-login'
    @key = 'my-secret-key'
  end

  it "Shorten long url using old API" do
    response = VCR.use_cassette('shorten_long_url') do
      Bitly.shorten("http://google.com", @login, @key)
    end

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.new_hash.should == 3
    response.global_hash.should_not be_empty
    response.hash_path.length.should_not == 0
    response.url.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end
  
  it 'Shorten long url using options API' do
    response = VCR.use_cassette('shorten_long_url') do
      Bitly.shorten(:long_url => "http://google.com", :login => @login, :api_key => @key)
    end

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.new_hash.should == 3
    response.global_hash.should_not be_empty
    response.hash_path.length.should_not == 0
    response.url.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end

  it 'Shorten url with a preferred domain' do
    response = VCR.use_cassette('shorten_long_url_with_preferred_domain') do
      Bitly.shorten(:long_url => "http://google.com", :domain => 'j.mp',
        :login => @login, :api_key => @key)
    end

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.new_hash.should == 3
    response.global_hash.should_not be_empty
    response.hash_path.length.should_not == 0
    response.url.should match /^http:\/\/j\.mp\/[A-Za-z0-9]*/
  end

  it "Shorten bitly url" do
    response = VCR.use_cassette('shorten_bitly_url') do
      Bitly.shorten("http://bit.ly/bcvNe5", @login, @key)
    end

    response.status_code.should == 500
  end

  it "Expand a short url to it long url" do
    response = VCR.use_cassette('expand_a_short_url_to_it_long_url') do
      Bitly.expand("http://bit.ly/bcvNe5", @login, @key)
    end

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.long_url.should == "http://google.com"
    response.short_url.should == "http://bit.ly/bcvNe5"
    response.user_hash.should == "bcvNe5"
  end

  it "Expand a long url should result an error" do
    response = VCR.use_cassette('expand_a_long_url_should_result_an_error') do
      Bitly.expand("http://google.com", @login, @key)
    end

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.long_url.should == "NOT_FOUND"
    response.short_url.should == "http://google.com"
  end


  it "Get clicks by short_url" do
    bitly = VCR.use_cassette('get_clicks_by_short_url') do
      Bitly.get_clicks("http://bit.ly/xlii42", @login, @key)
    end

    bitly.status_txt.should == "OK"
    bitly.status_code.should == 200
    bitly.global_clicks.should be_an_instance_of Fixnum
    bitly.user_clicks.should be_an_instance_of Fixnum
    bitly.short_url.should == "http://bit.ly/xlii42"
    bitly.global_hash.should == "cunZEP"
    bitly.user_hash.should == "cT1Izu"
  end
end
