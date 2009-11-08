module Admin::AuditsHelper

  def audited_ip_addresses
    @audited_ip_addresses ||= AuditEvent.find(:all, :select => :ip_address, :group => :ip_address).map(&:ip_address).compact
  end

  def audited_users
    @audited_users ||= AuditEvent.find(:all, :group => :user_id, :include => :user, :order => 'users.login').map(&:user).compact
  end

  def audited_event_types
    @audited_event_types ||= AuditEvent.find(:all, :select => 'auditable_type, audit_type_id', :group => 'auditable_type, audit_type_id').map(&:event_type).compact.sort
  end

  def filters_set?
    [params[:ip], params[:user], params[:event_type], params[:log], params[:auditable_id], params[:auditable_type]].compact.any?
  end

  def reverse_direction
    (params[:direction] == 'asc') ? 'desc' : 'asc'
  end
  
  def event_user_name(event)
    event.user.try(:login) || '(Unknown)'
  end

end
