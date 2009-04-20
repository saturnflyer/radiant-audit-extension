module Audit
  module UserExtensions
    # when logging out, the user model is updated to remove the session token,
    # which would cause a User update event to be logged.  logging_out is set
    # when the current user is logging out so only the logout event gets logged.
    # (see welcome_controller_extensions)
    def self.included(base)
      base.class_eval do
        attr_accessor :logging_out
      end
    end
  end
end