class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type
  
  include Auditable

  cattr_reader :per_page
  @@per_page = 100

  named_scope :ip,              lambda { |ip|   {:conditions => { :ip_address => ip }} }
  named_scope :user,            lambda { |user| {:conditions => { :user_id => user }} }
  named_scope :before,          lambda { |date| {:conditions => ['created_at <= ?', date.utc]} }
  named_scope :after,           lambda { |date| {:conditions => ['created_at >= ?', date.utc]} }
  named_scope :log,             lambda { |msg| {:conditions => ['log_message LIKE ?', "%#{msg}%"]} }
  named_scope :auditable_type,  lambda { |type| {:conditions => {:auditable_type => type}} }
  named_scope :auditable_id,    lambda { |type| {:conditions => {:auditable_id => id}} }
  named_scope :event_type,      lambda { |event|
    auditable, audit_type = event.split(' ')
    {:include => :audit_type, :conditions => { 'audit_types.name' => audit_type.upcase, :auditable_type => auditable}}
  }

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