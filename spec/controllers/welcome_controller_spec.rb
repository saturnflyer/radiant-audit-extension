require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::WelcomeController do
  dataset :users
  
  it "should log a login" do
    lambda {
      post :login, :user => {:login => "admin", :password => "Password1"}
    }.should change(AuditEvent, :count).by(1)
  end
  
  it "should log a failed login" do
    lambda {
      post :login, :user => {:login => "meow", :password => "mix"}
    }.should change(AuditEvent, :count).by(1)
  end
  
  it "should log a bad password" do
    lambda {
      post :login, :user => {:login => "admin", :password => "mix"}
    }.should change(AuditEvent, :count).by(1)
  end
  
  it "should log a logout" do
    login_as :admin
    lambda {
      get :logout 
    }.should change(AuditEvent, :count).by(1)
  end
  
end