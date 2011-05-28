require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyBitly" do

  before(:all) do
    @login = 'rafaeldx7'
    @key = 'R_59c1b174b21d92b2beeb4787a6d7ebaf'
  end

  it "Shorten long url" do
    response = Bitly.shorten("http://google.com", @login, @key)

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.new_hash.should == 0
    response.global_hash.should_not be_empty
    response.hash_path.length.should_not == 0
    response.url.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end

  it "Shorten bitly url" do
    response = Bitly.shorten("http://bit.ly/bcvNe5", @login, @key)

    response.status_code.should == 500
  end

  it "Expand a short url to it long url" do
    response = Bitly.expand("http://bit.ly/bcvNe5", @login, @key)

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.long_url.should == "http://google.com"
    response.short_url.should == "http://bit.ly/bcvNe5"
    response.user_hash.should == "bcvNe5"
  end

  it "Expand a long url should result an error" do
    response = Bitly.expand("http://google.com", @login, @key)

    response.status_code.should == 200
    response.status_txt.should == "OK"
    response.long_url.should == "NOT_FOUND"
    response.short_url.should == "http://google.com"
  end


  it "Get clicks by short_url" do
    bitly = Bitly.get_clicks("http://bit.ly/xlii42", @login, @key)

    bitly.status_txt.should == "OK"
    bitly.status_code.should == 200
    bitly.global_clicks.should be_an_instance_of Fixnum
    bitly.user_clicks.should be_an_instance_of Fixnum
    bitly.short_url.should == "http://bit.ly/xlii42"
    bitly.global_hash.should == "cunZEP"
    bitly.user_hash.should == "cT1Izu"
  end
end
