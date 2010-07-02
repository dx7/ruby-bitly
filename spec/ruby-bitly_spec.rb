require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyBitly" do
  
  it "Load personal data from ~/.bitly" do
    file_data = Bitly.load_personal_data
    file_data["key"].should_not be_empty
    file_data["login"].should_not be_empty
  end
  
  it "Shorten log url staticaly and return a hash" do
    response = Bitly.post_shorten "http://google.com"
  
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
    url.shorten
    
    url.status_code.should == 200
    url.status_txt.should == "OK"
    url.new_hash.should == 0
    url.global_hash == "zzzzzzz"
    url.hash.length.should_not == 0
    url.short_url.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
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
    url.expand
  
    url.long_url.should == "http://google.com"
    url.short_url.should == "http://bit.ly/bcvNe5"
    url.global_hash.should == "zzzzzzz"
    url.user_hash.should == "bcvNe5"
    url.status_code.should == 200
    url.status_txt.should == "OK"
  end
  
  it "Update object as read only" do
    url = Bitly.new
    url.read_only?.should be false
    url.read_only_now!
    url.read_only?.should be true
  end
  
  it "Shorten url and return an object" do
    url = Bitly.shorten("http://google.com")
    url.should be_an_instance_of(Bitly)
  
    url.status_code.should == 200
    url.status_txt.should == "OK"
    url.long_url.should == "http://google.com"
    url.new_hash.should == 0
    url.global_hash.should == "zzzzzzz"
    url.hash.should match /^[A-Za-z0-9]*$/
    url.short_url.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end
  
  it "New bitly object should be not read only" do
    url = Bitly.new
    url.read_only?.should be false
  end
  
  it "Shortened object should be read only" do
    url = Bitly.shorten "http://google.com"
    url.read_only?.should be true
  end
  
  it "Expanded object should be read only" do
    url = Bitly.expand "http://bit.ly/bcvNe5"
    url.read_only?.should be true
  end
  
  it "Attribute long_url should be updatable when object is not read only" do
    url = Bitly.new
    url.long_url = "http://google.com"
    url.long_url.should == "http://google.com"
    
    url.long_url = "http://xlii.com.br"
    url.long_url.should == "http://xlii.com.br"
  end
  
  it "Attribute long_url should not be updatable when object is read only" do
    url = Bitly.new
    url.long_url = "http://google.com"
    url.long_url.should == "http://google.com"
    url.read_only_now!
    
    url.long_url = "http://xlii.com.br"
    url.long_url.should == "http://google.com"
  end
  
  it "Expand url and return an object" do
    url = Bitly.expand "http://bit.ly/bcvNe5"
    url.should be_an_instance_of(Bitly)
  
    url.long_url.should == "http://google.com"
    url.short_url.should == "http://bit.ly/bcvNe5"
    url.global_hash.should == "zzzzzzz"
    url.user_hash.should == "bcvNe5"
    url.status_code.should == 200
    url.status_txt.should == "OK"
  end
  
  it "Attribute short_url should be updated when object is not read only" do
    url = Bitly.new
    url.short_url = "http://bit.ly/bcvNe5"
    url.short_url.should == "http://bit.ly/bcvNe5"
    
    url.short_url = "http://bit.ly/xlii42"
    url.short_url.should == "http://bit.ly/xlii42"
  end
  
  it "Attribute short_url should not be updated when object is read only" do
    url = Bitly.new
    url.short_url = "http://bit.ly/xlii42"
    url.short_url.should == "http://bit.ly/xlii42"
    url.read_only_now!
    
    url.short_url = "http://bit.ly/bcvNe5"
    url.short_url.should == "http://bit.ly/xlii42"
  end
end
