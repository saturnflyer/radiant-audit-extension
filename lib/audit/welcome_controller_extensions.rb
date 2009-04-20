module Audit
  module WelcomeControllerExtensions
    def self.included(base)
      base.class_eval do
        alias_method_chain :login, :auditing
        alias_method_chain :logout, :auditing
      end
    end
    
    private
    
    def login_with_auditing
      login_without_auditing
      if (current_user)
        AuditEvent.create({:auditable => current_user, :user => current_user, :ip_address => request.remote_ip, :audit_type => Audit::TYPES::LOGIN})
      end
    end
    
    def logout_with_auditing
      if (current_user)
        current_user.logging_out = true
        AuditEvent.create({:auditable => current_user, :user => current_user, :ip_address => request.remote_ip, :audit_type => Audit::TYPES::LOGOUT})
      end
      logout_without_auditing
    end
  end
end