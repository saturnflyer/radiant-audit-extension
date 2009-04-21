require File.dirname(__FILE__) + '/../spec_helper'

describe LayoutRegistration do
  it "should register CREATE" do
    Audit::TYPES::CREATE.log_formats[Layout].should_not be_nil
  end
  it "should register UPDATE" do
    Audit::TYPES::UPDATE.log_formats[Layout].should_not be_nil
  end
  it "should register DESTROY" do
    Audit::TYPES::DESTROY.log_formats[Layout].should_not be_nil
  end
end