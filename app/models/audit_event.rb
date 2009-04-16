class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  belongs_to :audit_type
  
  before_create :assemble_log_message
  
  private
  
  def assemble_log_message
    self.log_message = audit_type.log_formats[self.auditable.class].call(self)
  end
end
