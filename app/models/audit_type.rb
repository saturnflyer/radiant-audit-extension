class AuditType < ActiveRecord::Base
  attr_accessor :log_formats

  def after_initialize
    @log_formats ||= {}
  end

end
