class AuditsController < ApplicationController
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

    @audits = AuditEvent.find(:all, :conditions => ["created_at >= ? AND created_at < ?", @startdate, @enddate], :order => "created_at DESC")
    # some helper arrays for filter options
    @ip_addresses = @audits.map(&:ip_address).uniq
    @users = @audits.map(&:user).uniq.map(&:name)
    @event_types = @audits.collect { |a| a.event_type }.uniq
  end
end
