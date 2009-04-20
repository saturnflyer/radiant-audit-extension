class Audit::Registration
  extend ActionView::Helpers::UrlHelper
  extend ActionController::PolymorphicRoutes
  extend ActionView::Helpers::TagHelper
  extend ActionController::UrlWriter

  class << self
    def audits(klass)
      @@audit_class = klass
    end

    def register(method,&block)
      raise 'Please specify a class to audit' if @@audit_class.blank?
      Audit::TYPES.register method.to_s.upcase, @@audit_class, &block
    end
  end

end