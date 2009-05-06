class AuditsController < ApplicationController

  before_filter :include_stylesheet

  sphinx_resource   :sortable_attributes =>['created_at'],
                    :filterable_attributes => ['auditable_type', 'user_id', 'ip_address', 'audit_type_id', 'auditable_id'],
                    :range_attributes => ['created_at'],
                    :default_sort => "created_at",
                    :per_page => 100
  def index
    prepare_sphinx_results
    
    # filter by Event Type
    if !params[:event_type].blank?
      # event type comes through as "AUDITABLETYPE AUDITTYPE"; need to find both
      auditable_type, audit_type = params[:event_type].split(" ")
      audit_type_id = AuditType.find_by_name(audit_type).id
      params[:filter][:audit_type_id] = audit_type_id
      # convert "AUDITABLETYPE" => "Auditabletype"- it's a class name
      params[:filter][:auditable_type] = auditable_type.capitalize
    end

    # browse-by-date only shows one day at a time
    @startdate = params[:startdate].blank? ? Date.today : Date.parse(params[:startdate])
    @enddate = @startdate

    # calculate next and previous dates 
    @next_date = AuditEvent.find(:first, :select => :created_at, :conditions => ["created_at > ?", @enddate.next], :order => "created_at ASC")
    @previous_date = AuditEvent.find(:first, :select => :created_at, :conditions => ["created_at < ?", @startdate], :order => "created_at DESC")
    @next_date = @next_date.created_at unless @next_date.nil?
    @previous_date = @previous_date.created_at unless @previous_date.nil?

    # BROWSE-BY-DATE specific stuff
    @auditmenus = AuditEvent.find(:all, :conditions => ["created_at > :startdate AND created_at < :enddate", {:startdate => @startdate, :enddate => @enddate.next}])
    # some helper arrays for filter options
    @ip_addresses = @auditmenus.map(&:ip_address).uniq.compact
    @users = @auditmenus.map(&:user).uniq.compact
    @event_types = @auditmenus.collect { |a| a.event_type }.uniq.compact
    
    # default to chronological order for day view
    params[:direction] ||= 'asc'
    
    finalize_sphinx_results
  end
  
  def report
    prepare_sphinx_results
    
    if !params[:audit_type_name].blank?
      params[:filter][:audit_type_id] = AuditType.find_by_name(params[:audit_type_name]).id rescue nil
    end
    
    @startdate = params[:startdate].blank? ? "" : Date.parse(params[:startdate])
    # make enddate inclusive- show events through the enddate specified
    @enddate = params[:enddate].blank? ? "" : Date.parse(params[:enddate])
    
    finalize_sphinx_results
  end
  
  private
    def include_stylesheet
      @stylesheets << 'admin/audit'
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
      @audits = AuditEvent.search(sphinxed_search_terms, sphinxed_search_conditions)

      # Moving these params to save into controller, to be used on date "links"
      @params_to_pass = {}
      @params_to_pass[:filter] = {}
      @params_to_pass[:filter][:ip_address] = params[:filter][:ip_address]
      @params_to_pass[:filter][:user_id] = params[:filter][:user_id]
      @params_to_pass[:event_type] = params[:event_type]
      @params_to_pass[:query] = params[:query]

      @params_to_pass_for_previous_day = @params_to_pass.merge({ :startdate => @previous_date.strftime('%b %d, %Y') }).to_param unless @previous_date.nil?
      @params_to_pass_for_next_day = @params_to_pass.merge({ :startdate => @next_date.strftime('%b %d, %Y') }).to_param unless @next_date.nil?
    end
  
end
