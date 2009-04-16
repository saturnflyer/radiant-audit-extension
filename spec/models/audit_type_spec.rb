require File.dirname(__FILE__) + '/../spec_helper'

describe AuditType do
  before(:each) do
    @audit_type = AuditType.new
  end

  it "should be valid" do
    @audit_type.should be_valid
  end
end
