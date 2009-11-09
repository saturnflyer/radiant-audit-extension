require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::WelcomeController do
  dataset :users
  
  it "should log a login" do
    controller.should_receive(:audit).with(hash_including(:type => :login))
    post :login, :user => {:login => "admin", :password => "password"}
  end
  
  it "should log a failed login" do
    controller.should_receive(:audit).with(hash_including(:type => :bad_login))
    post :login, :user => {:login => "meow", :password => "mix"}
  end
  
  it "should log a bad password" do
    controller.should_receive(:audit).with(hash_including(:type => :bad_password))
    post :login, :user => {:login => "admin", :password => "mix"}
  end
  
  it "should log a logout" do
    login_as :admin
    controller.should_receive(:audit).with(hash_including(:type => :logout))
    get :logout
  end

  it "should not count remember-me as a separate update action" do
    lambda {
      post :login, :user => { :login => 'admin', :password => 'password'}, :remember_me => '1'
    }.should change(AuditEvent, :count).by(1)
  end
  
end