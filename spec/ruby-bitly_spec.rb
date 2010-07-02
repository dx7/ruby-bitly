require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyBitly" do
  
  it "Load personal data from ~/.bitly" do
    Bitly.load_personal_data.should == { "key" => "R_59c1b174b21d92b2beeb4787a6d7ebaf", "login" => "rafaeldx7" }
  end
  
  it "Shorten log url staticaly and return a hash" do
    response = Bitly.post_shorten("http://google.com")

    response["status_code"].should == 200
    response["status_txt"].should == "OK"
    response["data"]["new_hash"].should == 0
    response["data"]["global_hash"].should == "zzzzzzz"
    response["data"]["hash"].length.should_not == 0
    response["data"]["url"].should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end
  
  it "Shorten log url with an object" do
    url = Bitly.new
    url.long_url = "http://google.com"
    url.shorten.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
    
    url.status_code.should == 200
    url.status_txt.should == "OK"
    url.new_hash.should == 0
    url.global_hash == "zzzzzzz"
    url.hash.length.should_not == 0
    url.bitly.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end
  
  it "Expand short url to long url staticaly and return a hash" do
    Bitly.post_expand("http://bit.ly/bcvNe5").should == { "data"=> 
                                                      { "expand" => [ 
                                                        { "long_url" => "http://google.com",
                                                          "short_url" => "http://bit.ly/bcvNe5",
                                                          "global_hash" => "zzzzzzz", 
                                                          "user_hash" => "bcvNe5"}]
                                                        }, 
                                                        "status_txt" => "OK", 
                                                        "status_code" => 200
                                                      }
  end
  
  it "Expand short url to long url with an object" do
    url = Bitly.new

    url.short_url = "http://bit.ly/bcvNe5"
    url.expand.should == "http://google.com"
    url.long_url.should == "http://google.com"
    url.short_url.should == "http://bit.ly/bcvNe5"
    url.global_hash == "zzzzzzz"
    url.user_hash == "bcvNe5"
    url.status_code.should == 200
    url.status_txt.should == "OK"
  end
end
