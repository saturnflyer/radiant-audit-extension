module Audit
  module TYPES
    extend ActionView::Helpers::UrlHelper
    extend ActionController::PolymorphicRoutes
    
    # :MOVE
    def self.register(action, &block)
      audit_type = AuditType.find_or_create_by_name(action.to_s)
      unless const_defined? action
        const_set action, audit_type
      end
      const_get(action).log = block
    end

    register :CREATE do |event|
      name = if event.auditable.respond_to?(:name)
        link_to(event.auditable.name, "/admin/#{event.auditable.name.pluralize.downcase}/#{event.auditable.id}")
      elsif event.auditable.respond_to?(:title)
        link_to(event.auditable.title, "/admin/#{event.auditable.name.pluralize.downcase}/#{event.auditable.id}")
      else
        "#{event.auditable.class.name} #{event.auditable.id}"
      end
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " created #{name}"
    end

    register :UPDATE do |event|
      name = if event.auditable.respond_to?(:name)
        link_to(event.auditable.name, "/admin/#{event.auditable.name.pluralize.downcase}/#{event.auditable.id}")
      elsif event.auditable.respond_to?(:title)
        link_to(event.auditable.title, "/admin/#{event.auditable.name.pluralize.downcase}/#{event.auditable.id}")
      else
        "#{event.auditable.class.name} #{event.auditable.id}"
      end
      "#{event.user.name} updated #{name}"
    end

    register :DESTROY  do |event|
      name = if event.auditable.respond_to?(:name)
        event.auditable.name
      elsif event.auditable.respond_to?(:title)
        event.auditable.title
      else
        "#{event.auditable.class.name} #{event.auditable.id}"
      end
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " deleted #{name}"
    end

    register :LOGIN do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " logged in"
    end

    register :LOGOUT do |event|
      link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " logged out"
    end
  end
end          