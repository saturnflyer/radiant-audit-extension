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

end          