class Admin::AuditsController < ApplicationController

  before_filter :include_assets

  def index
    params[:direction] ||= 'asc'
    params[:date] &&= Date.parse(params[:date])
    params[:date] ||= Date.today
    @audits = scope_from_params
    
    if @audits.empty?
      @ip_addresses = params[:ip].blank? ? [] : [params[:ip]]
      if (!params[:user].blank?)
        @users = [User.find(params[:user])]
      end
      @users = [] if @users.nil?
      @event_types = params[:event_type].blank? ? [] : [params[:event_type]]

    else
      # some helper arrays for filter options - sorted
      @ip_addresses = @audits.map(&:ip_address).uniq.compact.sort
      @users = @audits.map(&:user).uniq.compact
      @users.sort!{ |x,y| x.login <=> y.login} # sort users by login
      @event_types = @audits.collect { |a| a.event_type }.uniq.compact.sort
    end
    
  end
  
  def report
    @audits = scope_from_params
  end
  
  private
    def include_assets
      @stylesheets << 'admin/date_picker'
      @stylesheets << { :href => 'admin/audit', :media => 'all' }
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