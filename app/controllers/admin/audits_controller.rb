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
    
    def scope_from_params(p = params)
      filters = %w(ip user event_type before date after log auditable_type auditable_id)
      filters.inject(AuditEvent) do |chain,filter|
        chain = chain.send(filter, p[filter]) unless p[filter].blank?
        chain
      end.paginate(:page => p[:page], :order => "audit_events.created_at #{sort_direction}")
    end

    def sort_direction
      params[:direction] == 'asc' ? 'asc' : 'desc'
    end

    def prepare_sphinx_results
      # in case no filter params are sent, don't choke on the params[:filter][:foo] below
      params[:filter] ||= {}
      # Remove blank params that sneak in the SELECT
      params[:filter].each_pair { |k,v| params[:filter].delete(k) if v.blank? }
    end
    
    def finalize_sphinx_results
      # date range
      # ThinkingSphinx apparently doesn't take logical operators, so we always need to provide it with an upper and lower bound for the date.
      if @startdate.blank?
        @startdate = AuditEvent.minimum(:created_at)
      end
      if @enddate.blank?
        @enddate = Date.today
      end

      params[:range] = "created_at" unless (@startdate.blank? && @enddate.blank?)
      params[:low] = Time.local(@startdate.year, @startdate.month, @startdate.day)
      # high = last second of the day
      params[:high] = Time.local(@enddate.year, @enddate.month, @enddate.day, 23, 59, 59)

      # default to sort by descending date
      params[:direction] ||= 'desc'

      # search for our audits with a little help from our friend Sphinx-it!
      @audits = AuditEvent.search(sphinxed_search_terms, sphinxed_search_conditions).compact

      # Moving these params to save into controller, to be used on date "links"
      @params_to_pass = {}
      @params_to_pass[:filter] = {}
      @params_to_pass[:filter][:ip_address] = params[:filter][:ip_address] unless params[:filter][:ip_address].blank?
      @params_to_pass[:filter][:user_id] = params[:filter][:user_id] unless params[:filter][:user_id].blank?
      @params_to_pass[:event_type] = params[:event_type] unless params[:event_type].blank?
      @params_to_pass[:query] = params[:query] unless params[:query].blank?
      @params_to_pass[:direction] = params[:direction] unless params[:direction].blank?
      @params_to_pass[:startdate] = params[:startdate] unless params[:startdate].blank?
      @params_to_pass[:enddate] = params[:enddate] unless params[:enddate].blank?
      @params_to_pass[:filter][:auditable_type] = params[:filter][:auditable_type] unless params[:filter][:auditable_type].blank?
      @params_to_pass[:filter][:auditable_id] = params[:filter][:auditable_id] unless params[:filter][:auditable_id].blank?


      @params_to_pass_for_previous_day = { :startdate => @previous_date.strftime('%F') }.to_param unless @previous_date.nil?
      @params_to_pass_for_next_day = { :startdate => @next_date.strftime('%F') }.to_param unless @next_date.nil?
    end
  
end