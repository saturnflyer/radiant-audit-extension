require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::WelcomeController do
  dataset :users
  
  it "should log a login" do
    count = AuditEvent.count
    post :login, :user => {:login => "admin", :password => "password"}
    AuditEvent.count.should == count+1
  end
  
  it "should log a logout" do
    post :login, :user => {:login => "admin", :password => "password"}
    count = AuditEvent.count
    get :logout
    AuditEvent.count.should == count+1
  end
  
end