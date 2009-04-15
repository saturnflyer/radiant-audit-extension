class AuditEvent < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  
  before_create :assemble_log_message
  
  private
  
  def assemble_log_message
    unless [Audit::TYPES::LOGIN, Audit::TYPES::LOGOUT].include?(event_type)
      name = auditable_type == "Page" ? auditable.title : auditable.name
      if !user
        self.log_message = "#{log_message} #{auditable_type} #{auditable_id}"
      else
        self.log_message = "#{user.name} #{log_message} #{auditable_type} #{auditable_id} (#{name})"
      end
    end
  end
end
