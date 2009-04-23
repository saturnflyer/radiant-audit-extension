require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::WelcomeController do
  dataset :users
  
  it "should log a login" do
    lambda {
      post :login, :user => {:login => "admin", :password => "password"}
    }.should change(AuditEvent, :count).by(1)
  end
  
  it "should log a logout" do
    login_as :admin
    lambda {
      get :logout 
    }.should change(AuditEvent, :count).by(1)
  end
  
end