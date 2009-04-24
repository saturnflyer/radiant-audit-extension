require File.dirname(__FILE__) + '/../spec_helper'

describe Audit do
  it "should log by default" do
    Audit.logging?.should be_true
  end

  it "should disable logging" do
    Audit.disable_logging
    Audit.logging?.should be_false
  end
  
  it "should enable logging" do
    Audit.disable_logging
    Audit.enable_logging
    Audit.logging?.should be_true
  end
  
  it "should temporarily disable logging" do
    Audit.disable_logging do
      Audit.logging?.should be_false
    end
    Audit.logging?.should be_true
  end

end