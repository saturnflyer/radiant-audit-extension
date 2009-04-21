module Audit
  module TYPES
    
    # register the action & class for its own AuditType
    def self.register(action, klass, &block)
      audit_type = AuditType.find_or_create_by_name(action.to_s)
      unless const_defined? action
        const_set action, audit_type
      end
      const_get(action).log_formats[klass] = block
    end

  end
end          