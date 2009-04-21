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

end