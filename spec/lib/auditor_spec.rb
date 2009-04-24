require File.dirname(__FILE__) + '/../spec_helper'

class Auditing
  include Auditor
end

describe Auditor do
  dataset :pages

  describe "#audit" do
    before do
      @auditor = Auditing.new
      @auditable = Page.first
      @user = User.first
    end

    it "should log a message" do
      event = @auditor.audit :item => @auditable, :user => @user, :ip => '127.0.0.1', :type => :update
      event.should be_kind_of(AuditEvent)
      event.auditable.should eql(@auditable)
      event.user.should eql(@user)
      event.audit_type.should eql(AuditType.find_by_name('update'))
    end

    it "should do nothing when logging disabled" do
      Audit.disable_logging
      lambda {
        @auditor.audit :item => @auditable, :user => @user, :ip => '127.0.0.1', :type => :update
      }.should_not change(AuditEvent, :count)
    end
  end
end