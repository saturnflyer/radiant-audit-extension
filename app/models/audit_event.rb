class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type

  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper

  # before the AuditEvent is saved, call the proc defined for this AuditType & class to assemble
  # appropriate log message
  before_create :assemble_log_message

  def event_type
    "#{auditable_type.upcase} #{audit_type.name}"
  end
  
  def user_link
    if user.nil?
      "Unknown User"
    else
      "<a href=\"/admin/users/#{user.id}\">#{user.name}</a>"
      # link_to(user.name, "/admin/users/#{user.id}")
    end
  end

  private
  def assemble_log_message
    self.log_message = audit_type.log_formats[self.auditable.class].call(self)
  end

end
