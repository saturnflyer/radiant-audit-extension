module Audit
  module PageExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable
        extend Auditor

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(h(event.auditable.title), event.auditable_path)
        end
        
        audit_event :update do |event|
          "#{event.user_link} updated " + link_to(h(event.auditable.title), event.auditable_path)
        end
        
        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(h(event.auditable.title), event.auditable_path)
        end
      end
    end

  end
end