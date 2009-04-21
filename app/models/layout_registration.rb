class LayoutRegistration < Audit::Registration
  audits Layout

  register :CREATE do |event|
    "#{event.user_link} created " + link_to(event.auditable.name, "/admin/layouts/#{event.auditable.id}")
  end

  register :UPDATE do |event|
    "#{event.user_link} updated " + link_to(event.auditable.name, "/admin/layouts/#{event.auditable.id}")
  end

  register :DESTROY do |event|
    "#{event.user_link} deleted #{event.auditable.name}"
  end
end