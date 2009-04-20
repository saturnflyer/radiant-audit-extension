module Audit
  module UserExtensions
    def self.included(base)
      base.class_eval do
        attr_accessor :logging_out
      end
    end
  end
end