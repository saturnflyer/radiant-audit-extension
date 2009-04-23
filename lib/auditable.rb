module Auditable
  include ActionController::UrlWriter
  include ActionView::Helpers::UrlHelper

  def audit_event(method, &block)
    Audit::TYPES.register method.to_s.upcase, self, &block
  end

  # override the built-in ActionController::UrlWriter#url_for since we
  # don't need most of it and those parts don't like being class methods anyway
  def url_for(options)
    options.delete(:only_path)
    ActionController::Routing::Routes.generate(options, {})
  end

end