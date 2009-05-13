require File.dirname(__FILE__) + '/../spec_helper'

class Audited
  extend Auditable
end

describe Auditable do
  before do
    @base = Audited
  end

  it "should have a formats hash" do
    @base.log_formats.should be_kind_of(Hash)
  end

  describe ".audit_event" do
    it "should register an event type" do
      lambda {
        @base.audit_event :bogus, &proc{}
      }.should change(AuditType, :count).by(1)
    end
    
    it "should map an existing event type" do
      AuditType.find_or_create_by_name('update')
      lambda {
        @base.audit_event :update, &proc{}
      }.should_not change(AuditType, :count)
    end

    it "should add event to formats hash" do
      format = proc { }
      @base.audit_event :bogus, &format
      @base.log_formats[:bogus].should eql(format)     
    end
  end

end