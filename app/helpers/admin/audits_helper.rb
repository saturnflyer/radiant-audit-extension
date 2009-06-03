module Admin::AuditsHelper
  def browse_by_date_filters_set?
    # have any filters been set on the browse_by_date form?
    !(params[:filter][:ip_address].blank? && params[:filter][:user_id].blank? && params[:event_type].blank? && params[:query].blank?)
  end
  
  def custom_report_filters_set?
    # have any filters been set on the custom_report form?
    !(params[:startdate].blank? && params[:enddate].blank? && params[:filter][:ip_address].blank? && params[:filter][:user_id].blank? && params[:filter][:auditable_type].blank? && params[:filter][:auditable_id].blank? && params[:filter][:audit_type_name].blank? && params[:query].blank?)
  end
end
