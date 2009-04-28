class AuditsController < ApplicationController

  sphinx_resource   :sortable_attributes =>['created_at'],
                    :filterable_attributes => ['auditable_type', 'user_id', 'ip_address', 'audit_type_id'],
                    :range_attributes => ['created_at'],
                    :default_sort => "created_at",
                    :per_page => 100

  def index
    # params for search:
    # => Date
    # => IP
    # => User
    # => Event Type
    # => Message Text (sphinx)
    # pagination (max 100 / PP)
    # default order by date
    @startdate = params[:startdate].nil? ? Date.today : Date.parse(params[:startdate])
    @enddate = params[:enddate].nil? ? @startdate.next : Date.parse(params[:enddate])
    @next_date = AuditEvent.find(:first, :select => :created_at, :conditions => ["created_at > ?", @enddate], :order => "created_at ASC")
    @previous_date = AuditEvent.find(:first, :select => :created_at, :conditions => ["created_at < ?", @startdate], :order => "created_at DESC")
    @next_date = @next_date.created_at unless @next_date.nil?
    @previous_date = @previous_date.created_at unless @previous_date.nil?

    # filter by Event Type
    if !params[:event_type].blank?
      # event type comes through as "AUDITABLETYPE AUDITTYPE"; need to find both
      auditable_type, audit_type = params[:event_type].split(" ")
      audit_type_id = AuditType.find_by_name(audit_type).id
      params[:filter][:audit_type_id] = audit_type_id
      # convert "AUDITABLETYPE" => "Auditabletype"- it's a class name
      params[:filter][:auditable_type] = auditable_type.capitalize
    end
    
    params[:range] = "created_at"
    params[:low] = Time.local(@startdate.year, @startdate.month, @startdate.day)
    params[:high] = Time.local(@enddate.year, @enddate.month, @enddate.day)
    
    # default to sort by descending date
    params[:direction] ||= 'desc'
    
    # @audits = AuditEvent.find(:all, :conditions => [conditions, conditionshash], :order => "created_at DESC")
    @audits = AuditEvent.search(sphinxed_search_terms, sphinxed_search_conditions)

    # show all filter options for this date range
    @auditmenus = AuditEvent.find(:all, :conditions => ["created_at > :startdate AND created_at < :enddate", {:startdate => @startdate, :enddate => @enddate}])
    # some helper arrays for filter options
    @ip_addresses = @auditmenus.map(&:ip_address).uniq.compact
    @users = @auditmenus.map(&:user).uniq.compact
    @event_types = @auditmenus.collect { |a| a.event_type }.uniq.compact
  end
end
