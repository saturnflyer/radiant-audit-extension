module Audit
  module LayoutExtensions

    def self.included(base)
      base.class_eval do
        extend Auditable
        
        updatables = ["name", "content"]
        
        audit_event :create do |event|
          "#{event.user_link} created " + link_to(event.auditable.name, event.auditable_path)
        end

        audit_event :update do |event|
          # take the intersection of any interesting fields that may have been updated 
          updated = (event.auditable.changed & updatables).join(", ") + " for" unless (event.auditable.changed & updatables).empty?
          
          "#{event.user_link} updated #{updated}" + link_to(event.auditable.name, event.auditable_path)
        end

        audit_event :destroy do |event|
          "#{event.user_link} deleted " + link_to(event.auditable.name, event.auditable_path)
        end
      end
    end

  end
end