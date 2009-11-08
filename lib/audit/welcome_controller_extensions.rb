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
      
      if (params[:user])
        if (current_user)
          audit :item => current_user, :user => current_user, :ip => request.remote_ip, :type => :login
        else
          # failed login! create a temporary user to pass the failed login info to the audit message
          if tmpuser = User.find_by_login(params[:user][:login])
            audit :item => tmpuser, :user => nil, :ip => request.remote_ip, :type => :bad_password
          else
            audit :item => User.new, :user => nil, :ip => request.remote_ip, :type => :bad_login
          end
        end
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