module Audit
  module UserExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.name, edit_admin_user_path(event.auditable))
        end

        audit_event :update do |event|
          "#{event.user_link} updated " + link_to(event.auditable.name, edit_admin_user_path(event.auditable))
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted #{event.auditable.name}"
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