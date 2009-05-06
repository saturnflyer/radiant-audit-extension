module Audit
  module UserExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.login, event.auditable_path)
        end

        audit_event :update do |event|
          # we are interested in the following fields to see if they've changed
          # it will be noted in the log message if any of the following fields have changed
          updatables = ["name", "email", "login", "password", "admin", "developer", "notes"]
          log_message = "#{event.user_link} updated " + link_to(event.auditable.login, event.auditable_path)
          log_message += " (#{(event.auditable.changed & updatables).join(", ")})" unless (event.auditable.changed & updatables).empty?
          log_message
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.login, event.auditable_path)
        end

        audit_event :login do |event|
          "#{event.user_link} logged in"
        end

        audit_event :logout do |event|
          "#{event.user_link} logged out"
        end
      end
    end

  end
end