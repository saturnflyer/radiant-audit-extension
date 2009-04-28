class AuditsController < ApplicationController

  sphinx_resource   :audit_event,
                    :sortable_attributes =>['created_at'],
                    :default_sortable_attribute => "created_at",
                    :default_alphabetical_index_attribute => "log_message_sort",
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

    # # filter by date
    # conditions = "created_at > :startdate AND created_at < :enddate"
    # conditionshash = {:startdate => @startdate, :enddate => @enddate}
    # 
    # # filter by IP Address
    # if !params[:ip_address].blank?
    #   conditions += " AND ip_address = :ip_address"
    #   conditionshash[:ip_address] = params[:ip_address]
    # end
    # 
    # # filter by User ID
    # if !params[:user_id].blank?
    #   conditions += " AND user_id = :user_id"
    #   conditionshash[:user_id] = params[:user_id]
    # end

    # filter by Event Type
    # if !params[:event_type].blank?
    #   # event type comes through as "AUDITABLETYPE AUDITTYPE"; need to find both
    #   auditable_type, audit_type = params[:event_type].split(" ")
    #   audit_type_id = AuditType.find_by_name(audit_type).id
    #   conditions += " AND auditable_type = :auditable_type AND audit_type_id = :audit_type_id"
    #   conditionshash[:audit_type_id] = audit_type_id
    #   # convert "AUDITABLETYPE" => "Auditabletype"- it's a class name
    #   conditionshash[:auditable_type] = auditable_type.capitalize
    # end
    
    # @audits = AuditEvent.find(:all, :conditions => [conditions, conditionshash], :order => "created_at DESC")
    @audits = AuditEvent.search(sphinxed_search_terms, sphinxed_search_conditions)

    # some helper arrays for filter options
    @ip_addresses = @audits.map(&:ip_address).uniq.compact
    @users = @audits.map(&:user).uniq.compact
    @event_types = @audits.collect { |a| a.event_type }.uniq.compact
  end
end
