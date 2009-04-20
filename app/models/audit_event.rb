class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type

  extend ActionView::Helpers::UrlHelper
  extend ActionView::Helpers::TagHelper

  def event_type
    "#{auditable_type.upcase} #{audit_type.name}"
  end
  
  private
  def user_link
    if user.nil?
      "Unknown User"
    else
      "<a href=\"/admin/users/#{user.id}\">#{user.name}</a>"
      # link_to(user.name, "/admin/users/#{user.id}")
    end
  end

end
