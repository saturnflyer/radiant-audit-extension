module Audit
  module TYPES
    extend ActionView::Helpers::UrlHelper
    extend ActionController::PolymorphicRoutes
    extend ActionView::Helpers::TagHelper
    extend ActionController::UrlWriter
    
    # :MOVE
    def self.register(action, klass, &block)
      audit_type = AuditType.find_or_create_by_name(action.to_s)
      unless const_defined? action
        const_set action, audit_type
      end
      const_get(action).log_formats = {}
      const_get(action).log_formats[klass] = block
    end

    register :CREATE, Page do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " created " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
    end

    register :UPDATE, Page do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " updated " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
    end

    register :DESTROY, Page  do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " deleted #{event.auditable.title}"
    end

    register :LOGIN, User do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " logged in"
    end

    register :LOGOUT, User do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " logged out"
    end
  end
end          