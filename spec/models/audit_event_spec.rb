require File.dirname(__FILE__) + '/../spec_helper'

describe AuditEvent do
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionController::UrlWriter
  dataset :users

  it "should link to user" do
    admin = users(:admin)
    audit = AuditEvent.new(:user => admin)
    audit.user_link.should eql(link_to(admin.name, edit_admin_user_path(admin)))
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

end