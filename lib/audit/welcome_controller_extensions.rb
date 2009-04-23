module Audit
  module WelcomeControllerExtensions
    def self.included(base)
      base.class_eval do
        include Auditor
        after_filter :audit_login, :only => :login
        around_filter :audit_logout, :only => :logout
      end
    end

    private
    
    def audit_login
      if (current_user)
        audit :item => current_user, :user => current_user, :ip => request.remote_ip, :type => :login
      end
    end

    def audit_logout
      if (current_user)
        audit :item => current_user, :user => current_user, :ip => request.remote_ip, :type => :logout
      end
      Audit.disable_logging do
        yield
      end
    end
  end
end