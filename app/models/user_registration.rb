class UserRegistration < Audit::Registration
  audits User

  register :CREATE do |event|
    "#{event.user_link} created " + link_to(event.auditable.name, edit_admin_user_path(event.auditable))
  end

  register :UPDATE do |event|
    "#{event.user_link} updated " + link_to(event.auditable.name, edit_admin_user_path(event.auditable))
  end

  register :DESTROY do |event|
    "#{event.user_link} deleted #{event.auditable.name}"
  end

  register :LOGIN do |event|
    "#{event.user_link} logged in"
  end

  register :LOGOUT do |event|
    "#{event.user_link} logged out"
  end
end