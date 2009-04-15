class AuditObserver < ActiveRecord::Observer
  observe User, Page, Layout, Snippet
  
  cattr_accessor :current_user
  cattr_accessor :current_ip
  
  def after_create(model)
    log_message = "created"
    AuditEvent.create({:auditable => model, :user => @@current_user, :ip_address => @@current_ip, :event_type => Audit::TYPES::CREATE, :log_message => log_message})
  end

  def after_update(model)
    log_message = "updated"
    AuditEvent.create({:auditable => model, :user => @@current_user, :ip_address => @@current_ip, :event_type => Audit::TYPES::UPDATE, :log_message => log_message})
  end
  
  def after_destroy(model)
    log_message = "destroyed"
    AuditEvent.create({:auditable => model, :user => @@current_user, :ip_address => @@current_ip, :event_type => Audit::TYPES::DESTROY, :log_message => log_message})
  end

end