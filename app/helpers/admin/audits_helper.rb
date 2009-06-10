module Admin::AuditsHelper
  def browse_by_date_filters_set?
    # have any filters been set on the browse_by_date form?
    not [params[:ip], params[:user], params[:event_type], params[:log]].all?(&:blank?)
  end
  
  def custom_report_filters_set?
    # have any filters been set on the custom_report form?
    not [params[:before], params[:after], params[:ip], params[:user], params[:auditable_type], params[:auditable_id], params[:event_type], params[:log]].all? &:blank?
  end

  def reverse_direction
    (params[:direction] == 'asc') ? 'desc' : 'asc'
  end
end
