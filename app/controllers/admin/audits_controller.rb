class Admin::AuditsController < ApplicationController

  before_filter :include_assets

  def index
    params[:direction] ||= 'asc'
    params[:date] &&= Date.parse(params[:date])
    params[:date] ||= Date.today
    @audits = scope_from_params
    
    # some helper arrays for filter options - sorted
    @ip_addresses = @audits.map(&:ip_address).uniq.compact.sort
    @users = @audits.map(&:user).uniq.compact
    @users.sort!{ |x,y| x.login <=> y.login} # sort users by login
    @event_types = @audits.collect { |a| a.event_type }.uniq.compact.sort
  end
  
  def report
    @audits = scope_from_params
  end
  
  private
    def include_assets
      @stylesheets << 'admin/date_picker'
      @stylesheets << 'admin/audit'
      @javascripts << 'lowpro'
      @javascripts << 'prototype_extensions'
      @javascripts << 'admin/DatePicker'
      @javascripts << 'admin/audit'
    end
    
    def scope_from_params
      filters = %w(ip user event_type before date after log auditable_type auditable_id)
      filters.inject(AuditEvent) do |chain,filter|
        chain = chain.send(filter, params[filter]) unless params[filter].blank?
        chain
      end.paginate(:page => params[:page], :order => "audit_events.created_at #{sort_direction}")
    end

    def sort_direction
      params['direction'] == 'asc' ? 'asc' : 'desc'
    end
  
end