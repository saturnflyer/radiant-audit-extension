module Audit
  module WelcomeControllerExtensions
    def self.included(base)
      base.class_eval do
        include Auditor
        alias_method_chain :login, :auditing
        alias_method_chain :logout, :auditing
      end
    end
    
    private
    
    def login_with_auditing
      login_without_auditing
      if (current_user)
        audit :item => current_user, :user => current_user, :ip => request.remote_ip, :type => Audit::TYPES::LOGIN
      end
    end
    
    def logout_with_auditing
      if (current_user)
        current_user.logging_out = true
        audit :item => current_user, :user => current_user, :ip => request.remote_ip, :type => Audit::TYPES::LOGOUT
      end
      logout_without_auditing
    end
  end
end