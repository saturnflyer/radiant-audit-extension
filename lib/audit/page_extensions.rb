module Audit
  module PageExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable

        audit_event :CREATE do |event|
          "#{event.user_link} created " + link_to(event.auditable.title, edit_admin_page_path(event.auditable))
        end

        audit_event :UPDATE do |event|
          if event.auditable.status_id_changed?
            case event.auditable.status.name
            when 'Published' : "#{event.user_link} published " + link_to(event.auditable.title, edit_admin_page_path(event.auditable))
            end
          else
            "#{event.user_link} updated " + link_to(event.auditable.title, edit_admin_page_path(event.auditable))
          end
        end

        audit_event :DESTROY do |event|
          "#{event.user_link} deleted #{event.auditable.title}"
        end
      end
    end

  end
end