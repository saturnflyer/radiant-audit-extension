require File.dirname(__FILE__) + '/../spec_helper'

describe AuditEvent do
  include ActionController::UrlWriter

  dataset :users, :pages

  it "should link to the custom report view for the user" do
    admin = users(:admin)
    audit = AuditEvent.new(:user => admin)
    audit.user_link.should eql("<a href=\"#{report_admin_audits_path(:user => users(:admin))}\">#{admin.login}</a>")
  end
  
  it "should link to the custom report view for the auditable" do
    admin = users(:admin)
    auditable = pages(:home)
    audit = AuditEvent.new(:user => admin, :auditable => auditable)
    audit.auditable_path.should eql(report_admin_audits_path(:auditable_type => 'Page', :auditable_id => page_id(:home)))
  end
  
  it "should return 'Unknown User' if unknown user" do
    audit = AuditEvent.new
    audit.user_link.should eql("Unknown User")
  end

  it "should not write logs when Audit.logging is disabled" do
    Audit.disable_logging
    lambda {
      User.create!(user_params)
    }.should_not change(AuditEvent, :count)
  end

  it "should take a symbol as an audit type" do
    user = users(:admin)
    event = AuditEvent.new(:auditable => user, :user => user, :ip_address => '127.0.0.1', :audit_type => :create)
    event.audit_type.should eql(AuditType.find_by_name('create'))
  end
  
  it "should find log format in auditable's class" do
    Page.log_formats[:bogus] = proc { 'log message' }
    event = AuditEvent.new :auditable => Page.new, :audit_type => :bogus
    msg = event.send(:assemble_log_message)
    msg.should eql('log message')
  end

  describe ".date_before" do
    dataset :audit

    it "should be nil" do
      AuditEvent.date_before(audit_events(:first).created_at).should be_nil
    end

    it "should be the previous date" do
      AuditEvent.date_before(audit_events(:third).created_at).should eql(audit_events(:second).created_at.to_date)
    end
  end

  describe ".date_after" do
    dataset :audit

    it "should be nil" do
      AuditEvent.date_after(audit_events(:third).created_at).should eql(nil)
    end

    it "should be the next date" do
      AuditEvent.date_after(audit_events(:first).created_at).should eql(audit_events(:second).created_at.to_date)
    end
  end

  describe "event_type scope" do
    dataset :audit

    it "should capitalize classes" do
      AuditEvent.event_type('page UPDATE').should == AuditEvent.event_type('Page UPDATE')
    end

    it "should upcase events" do
      AuditEvent.event_type('Page update').should == AuditEvent.event_type('Page UPDATE')
    end
  end

end