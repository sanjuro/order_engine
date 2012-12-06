require 'spec_helper'
 
describe "ApiErrorHandler" do
 
  subject { Class.new(Grape::API) }  
  def app; subject end
  
  describe "error" do
  
    before do
      subject.prefix 'api'
      subject.use ApiErrorHandler
      subject.get :error do
        raise "api error"
      end
      subject.get :hello do
        { hello: "world" }
      end
    end
 
    it "should return world when asked hello" do    
      get '/api/hello'
      JSON.parse(response.body).should == { "hello" => "world" }
      response.status.should == 200
    end
    
    it "should return a 500 when an exception is raised" do    
      get '/api/error'
      response.status.should == 500
      response.body.should == "api error"
    end
    
  end
end