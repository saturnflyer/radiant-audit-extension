class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type
  
  # sphinxable_resource / thinking sphinx indices
  define_index do
    indexes log_message, ip_address, user_id, auditable_type, auditable_id, audit_type_id
    has created_at, :sortable => true
    set_property :delta => true
  end


  # before the AuditEvent is saved, call the proc defined for this AuditType & class to assemble
  # appropriate log message
  before_create :assemble_log_message

  def event_type
    "#{auditable_type} #{audit_type.name.gsub(/_/, " ").titleize}"
  end
  
  def user_link
    if user.nil?
      "Unknown User"
    else
      "<a href='/admin/audits/report?filter[user_id]=#{user.id}'>#{user.login}</a>"
    end
  end

  def auditable_path
    "/admin/audits/report?filter[auditable_type]=#{auditable_type}&filter[auditable_id]=#{auditable_id}"
  end

  def audit_type_with_cast=(type)
    @event_type = type.to_sym
    type = AuditType.find_by_name(type.to_s.upcase)
    self.audit_type_without_cast = type
  end
  alias_method_chain :audit_type=, :cast

  private
  def assemble_log_message
    return false unless Audit.logging?
    self.log_message = self.auditable.class.log_formats[@event_type].call(self)
  end

end