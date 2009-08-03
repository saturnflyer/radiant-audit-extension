module Audit
  module PageExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable
        extend Auditor

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.title, event.auditable_path) + " (" + link_to("link", edit_admin_page_path(event.auditable.id)) + ")"
        end
        
        audit_event :update do |event|
          log_message = "#{event.user_link} updated " + link_to(event.auditable.title, event.auditable_path)
          log_message += " to revision #{event.auditable.revisions.first.number}"
          log_message += " (" + link_to("link", edit_admin_page_path(event.auditable.id)) + ")"
          log_message
        end
        
        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.title, event.auditable_path)
        end
      end
    end

  end
end