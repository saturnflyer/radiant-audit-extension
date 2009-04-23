class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionController::UrlWriter

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
      link_to(user.name, edit_admin_user_path(user))
    end
  end

  def audit_type_with_cast=(type)
    if type.is_a?(Symbol)
      type = Audit::TYPES.const_get(type.to_s.upcase)
    end
    self.audit_type_without_cast = type
  end
  alias_method_chain :audit_type=, :cast

  private
  def assemble_log_message
    return false if not Audit.logging?
    self.log_message = audit_type.log_formats[self.auditable.class.base_class].call(self)
  end

end
