require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyBitly" do
  
  it "Load personal data from ~/.bitly" do
    Bitly.load_personal_data.should == { "key" => "R_59c1b174b21d92b2beeb4787a6d7ebaf", "login" => "rafaeldx7" }
  end
  
  it "Shorten log url staticaly" do
    response = Bitly.shorten("http://google.com")

    response["status_code"].should == 200
    response["status_txt"].should == "OK"
    response["data"]["new_hash"].should == 0
    response["data"]["global_hash"].should == "zzzzzzz"
    response["data"]["hash"].length.should_not == 0
    response["data"]["url"].should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end
  
  it "Shorten log url OO" do
    url = Bitly.new("http://google.com")
    url.shorten.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
    
    url.status_code.should == 200
    url.status_txt.should == "OK"
    url.new_hash.should == 0
    url.global_hash == "zzzzzzz"
    url.hash.length.should_not == 0
    url.bitly.should match /^http:\/\/bit\.ly\/[A-Za-z0-9]*/
  end
end
