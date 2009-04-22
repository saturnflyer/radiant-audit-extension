module Auditor
  def audit(args={})
    return if AuditEvent.logging_disabled
    args = HashWithIndifferentAccess.new(args)
    AuditEvent.create :auditable => args[:item], :user => args[:user], :ip_address => args[:ip], :audit_type => args[:type]
  end
end