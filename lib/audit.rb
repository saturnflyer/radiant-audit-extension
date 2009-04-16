module Audit
  module TYPES
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
        event.auditable.name
      elsif event.auditable.respond_to?(:title)
        event.auditable.title
      else
        "#{event.auditable.class.name} #{event.auditable.id}"
      end
        "#{event.user.name} created #{name}"
    end

    register :UPDATE do |event|
      name = if event.auditable.respond_to?(:name)
        event.auditable.name
      elsif event.auditable.respond_to?(:title)
        event.auditable.title
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
        "#{event.user.name} deleted #{name}"
    end

    register :LOGIN do |event|
      "#{event.user.name} logged in"
    end

    register :LOGOUT do |event|
      "#{event.user.name} logged out"
    end
  end
end          