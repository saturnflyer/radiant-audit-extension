module Auditable
  include ActionController::UrlWriter
  include ActionView::Helpers::UrlHelper

  def self.extended(base)
    base.class_eval do
      class_inheritable_hash :log_formats
      self.log_formats = {}
    end
  end

  def audit_event(method, &block)
    # checking if AuditType is defined yet so the initial migration can happen
    AuditType.find_or_create_by_name(method.to_s.upcase) if ActiveRecord::Base.connection.tables.include?(AuditType.table_name)
    self.log_formats[method.to_sym] = block
  end

  # Bypass most of ActionController::UrlWriter#url_for. Most of the assumed
  # methods/vars won't be in existence.
  def url_for(options)
    return options if options.is_a?(String)
    options.delete :only_path
    ActionController::Routing::Routes.generate(options)
  end
end