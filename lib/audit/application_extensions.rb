module Audit
  module ApplicationExtensions
    def self.included(base)
      base.class_eval do
        before_filter :set_current_user_and_ip
      end
    end
    
    private
    
    def set_current_user_and_ip
      AuditObserver.current_user = current_user
      AuditObserver.current_ip = request.remote_ip
    end
  end
end