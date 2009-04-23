module Audit
  @@logging_disabled = false

  class << self
    def disable_logging
      @@logging_disabled = true
      if block_given?
        yield
        @@logging_disabled = false
      end
    end

    def enable_logging
      @@logging_disabled = false
    end

    def logging?
      not @@logging_disabled
    end
  end

  module TYPES

    # register the action & class for its own AuditType
    def self.register(action, klass, &block)
      return if not Audit.logging?
      audit_type = AuditType.find_or_create_by_name(action.to_s)
      unless const_defined? action
        const_set action, audit_type
      end
      const_get(action).log_formats[klass] = block
    end

  end
end          