module Audit
  module LayoutExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable
        
        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.name, edit_admin_layout_path(event.auditable))
        end

        audit_event :update do |event|
          "#{event.user_link} updated " + link_to(event.auditable.name, edit_admin_layout_path(event.auditable))
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted #{event.auditable.name}"
        end
      end
    end

  end
end