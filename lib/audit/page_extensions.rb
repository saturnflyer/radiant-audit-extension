module Audit
  module PageExtensions

    def self.included(base)
      base.const_set("OBSERVABLE_FIELDS", [:status_id])

      base.class_eval do
        extend Auditable
        extend Auditor

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.title, event.auditable_path)
        end
        
        audit_event :update do |event|
          # list any fields that we're interested in that were updated
          updatables = ["title", "slug", "breadcrumb", "description", "keywords"]

          updated = (event.auditable.changed & updatables).join(", ") + " for" unless (event.auditable.changed & updatables).empty?
          "#{event.user_link} updated #{updated} " + link_to(event.auditable.title, event.auditable_path)
        end
        
        # separate event for logging page status changes- fired after page :update if the status has changed.
        audit_event :status_id_changed do |event|
          "#{event.user_link} changed the status of " + link_to(event.auditable.title, event.auditable_path) + " to #{event.auditable.status.name}"
        end
        
        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.title, event.auditable_path)
        end
      end
    end

  end
end
