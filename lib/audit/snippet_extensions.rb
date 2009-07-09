module Audit
  module SnippetExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.name, event.auditable_path)
        end

        audit_event :update do |event|
          # we are interested in the following fields to see if they've changed
          # it will be noted in the log message if any of the following fields have changed
          updatables = ["name", "content"]
          log_message = "#{event.user_link} updated " + link_to(event.auditable.name, event.auditable_path)
          log_message += updated_fields(updatables, event.auditable)
          log_message
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.name, event.auditable_path)
        end
      end
    end

  end
end