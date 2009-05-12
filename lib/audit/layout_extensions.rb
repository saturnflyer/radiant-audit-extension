module Audit
  module LayoutExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable
        
        audit_event :create do |event|
          "#{event.user_link} created <a href='#{event.auditable.name}'>#{event.auditable_path}</a>"
        end

        audit_event :update do |event|
          # we are interested in the following fields to see if they've changed
          # it will be noted in the log message if any of the following fields have changed
          updatables = ["name", "content"]
          log_message = "#{event.user_link} updated <a href='#{event.auditable.name}'>#{event.auditable_path}</a>"
          log_message += " (#{(event.auditable.changed & updatables).join(", ")})" unless (event.auditable.changed & updatables).empty?
          log_message
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted <a href='#{event.auditable.name}'>#{event.auditable_path}</a>"
        end
      end
    end

  end
end