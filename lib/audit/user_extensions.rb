module Audit
  module UserExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        updatables = ["name", "email", "login", "password", "admin", "developer", "notes"]

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.login, event.auditable_path)
        end

        audit_event :update do |event|
          # take the intersection of any interesting fields that may have been updated 
          updated = (event.auditable.changed & updatables).join(", ") + " for " unless (event.auditable.changed & updatables).empty?
          "#{event.user_link} updated #{updated}" + link_to(event.auditable.login, event.auditable_path)
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