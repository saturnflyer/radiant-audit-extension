class AuditsController < ApplicationController
  def index
    @audits = AuditEvent.all
  end
end
