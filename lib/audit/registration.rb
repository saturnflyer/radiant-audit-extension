class Audit::Registration
  extend ActionView::Helpers::UrlHelper

  class << self
    include ActionController::UrlWriter

    def audits(klass)
      @@audit_class = klass
    end

    def register(method,&block)
      raise 'Please specify a class to audit' if @@audit_class.blank?
      return unless ActiveRecord::Base.connection.tables.include?(AuditType.table_name)
      Audit::TYPES.register method.to_s.upcase, @@audit_class, &block
    end

    # override the built-in ActionController::UrlWriter#url_for since we
    # don't need most of it and those parts don't like being class methods anyway
    def url_for(options)
      options.delete(:only_path)
      ActionController::Routing::Routes.generate(options, {})
    end
  end

end