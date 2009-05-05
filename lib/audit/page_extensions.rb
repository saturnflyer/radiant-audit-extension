module Audit
  module PageExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable
        extend Auditor
        
        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.title, event.auditable_path)
        end

        updatables = ["title", "slug", "breadcrumb", "description", "keywords"]

        audit_event :update do |event|
          if event.auditable.status_id_changed?
            audit :item => event.auditable, :user => event.user, :ip => event.ip_address, :type => :status_change
          end
          # take the intersection of any interesting fields that may have been updated
          updated = (event.auditable.changed & updatables).join(", ") + " for" unless (event.auditable.changed & updatables).empty?
          "#{event.user_link} updated #{updated} " + link_to(event.auditable.title, event.auditable_path)
        end

        audit_event :status_change do |event|
          "#{event.user_link} changed the status of " + link_to(event.auditable.title, event.auditable_path) + " to #{event.auditable.status.name}"
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.title, event.auditable_path)
        end
      end
    end

  end
end