class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type
  
  include Auditable

  named_scope :ip,    lambda { |ip|   {:conditions => { :ip_address => ip }} }
  named_scope :user,  lambda { |user| 
    user = user.id if user.is_a?(User)
    {:conditions => { :user_id => user }} 
  }
  named_scope :event_type,  lambda { |event| 
    auditable, audit_type = event.split(' ')
    audit_type_id = AuditType.find_by_name(audit_type.upcase)
    {:conditions => { :audit_type_id => audit_type_id, :auditable_type => auditable}}
  }
  named_scope :between, lambda { |*args|
    low = args[0] || AuditEvent.minimum(:created_at)
    high = args[1] || AuditEvent.maximum(:created_at)
    {:conditions => ['created_at BETWEEN ? AND ?', low.utc, high.utc]}
  }
  named_scope :log, lambda { |msg| {:conditions => ['log_message LIKE ?', "%#{msg}%"]} }
  named_scope :auditable_type, lambda { |type| {:conditions => {:auditable_type => type}} }
  named_scope :auditable_id, lambda { |type| {:conditions => {:auditable_id => id}} }

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
      link_to user.login, admin_audits_report_path(:filter => {:user_id => user_id})
    end
  end

  def auditable_path
    admin_audits_report_path(:filter => { :auditable_type => auditable_type, :auditable_id => auditable_id})
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