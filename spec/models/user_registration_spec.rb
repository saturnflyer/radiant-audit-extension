require File.dirname(__FILE__) + '/../spec_helper'

describe UserRegistration do
  it "should register CREATE" do
    Audit::TYPES::CREATE.log_formats[User].should_not be_nil
  end
  it "should register UPDATE" do
    Audit::TYPES::UPDATE.log_formats[User].should_not be_nil
  end
  it "should register DESTROY" do
    Audit::TYPES::DESTROY.log_formats[User].should_not be_nil
  end
  it "should register LOGIN" do
    Audit::TYPES::LOGIN.log_formats[User].should_not be_nil
  end
  it "should register LOGOUT" do
    Audit::TYPES::LOGOUT.log_formats[User].should_not be_nil
  end
end