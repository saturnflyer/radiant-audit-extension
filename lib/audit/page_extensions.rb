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
          # we are interested in the following fields to see if they've changed
          # it will be noted in the log message if any of the following fields have changed
          updatables = ["title", "slug", "breadcrumb", "description", "keywords"]

          log_message = "#{event.user_link} updated " + link_to(event.auditable.title, event.auditable_path)
          log_message += updated_fields(updatables, event.auditable)
          log_message
        end
        
        # separate event for logging page status changes- fired after page :update if the status has changed.
        audit_event :status_change do |event|
          oldstatus = Status.find_all.reject{|x| x.id != event.auditable.status_id_was}.first.name
          log_message = "#{event.user_link} changed the status of " + link_to(event.auditable.title, event.auditable_path)
          log_message += " from #{oldstatus}" unless oldstatus.blank?
          log_message += " to #{event.auditable.status.name}"
        end
        
        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.title, event.auditable_path)
        end
      end
    end

  end
end