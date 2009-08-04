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
  
  def entify_ampersands(snippet)
    snippet.gsub("amp;","").gsub("&","&amp;")
  end
  
  def event_user_name(event)
    if event.user.nil?
      event.log_message.match(/^File\sSystem/) ? "File System" : "(Unknown)"
    else
      event.user.login
    end
  end

  def item_link
    case @item
    when Page : link_to @item.title, edit_admin_page_path(@item)
    when Snippet : link_to @item.name, edit_admin_snippet_path(@item)
    when Layout : link_to @item.name, edit_admin_layout_path(@item)
    when User : link_to @item.login, edit_admin_user_path(@item)
    else ''
    end
  end
end
