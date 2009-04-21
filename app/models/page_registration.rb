class PageRegistration < Audit::Registration
  audits Page

  register :CREATE do |event|
    "#{event.user_link} created " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
  end

  register :UPDATE do |event|
    if event.auditable.status_id_changed?
      case event.auditable.status.name
      when 'Published' : "#{event.user_link} published " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
      end
    else
      "#{event.user_link} updated " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
    end
  end

  register :DESTROY do |event|
    "#{event.user_link} deleted #{event.auditable.title}"
  end
  
end