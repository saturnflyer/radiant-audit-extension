module Audit
  module PageExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.title, event.auditable_path)
        end

        audit_event :update do |event|
          if event.auditable.status_id_changed?
            case event.auditable.status.name
            when 'Published' : "#{event.user_link} published " + link_to(event.auditable.title, event.auditable_path)
            end
          else
            "#{event.user_link} updated " + link_to(event.auditable.title, event.auditable_path)
          end
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.title, event.auditable_path)
        end
      end
    end

  end
end