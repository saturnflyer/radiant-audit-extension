module Admin::AuditsHelper
  def browse_by_date_filters_set?
    # have any filters been set on the browse_by_date form?
    [params[:ip], params[:user], params[:event_type], params[:log], params[:auditable_id], params[:auditable_type]].compact.any?
  end

  def reverse_direction
    (params[:direction] == 'asc') ? 'desc' : 'asc'
  end
  
  def entify_ampersands(snippet)
    snippet.gsub("amp;","").gsub("&","&amp;")
  end
  
  def event_user_name(event)
    event.user.try(:login)
  end

  def item_link
    case @item
    when Page : link_to @item.title, edit_admin_page_path(@item)
    when Snippet : link_to @item.name, edit_admin_snippet_path(@item)
    when Layout : link_to @item.name, edit_admin_layout_path(@item)
    when User : link_to @item.login, edit_admin_user_path(@item)
    when nil
      if params[:auditable_type] and params[:auditable_id] and AuditEvent.find_by_auditable_type_and_auditable_id(params[:auditable_type], params[:auditable_id])
        "#{(h params[:auditable_type]).camelcase} ##{h params[:auditable_id]} (deleted)"
      end
    end
  end
end
