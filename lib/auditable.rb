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
  
  # helper function to collect any updated fields that we're interested in.
  def updated_fields(updatables, auditable)
    # ignore fields that went from nil to "".
    updated = auditable.changes.collect {|a|
      if updatables.include?(a[0]) && !(a[1][0].nil? && a[1][1] == "")
        a[0]
      end
    }.compact.join(", ")
  
    if updated.empty?
      ""
    else
      " (#{updated})"
    end
  end
  
  

end