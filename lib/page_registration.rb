extend ActionView::Helpers::UrlHelper
extend ActionController::PolymorphicRoutes
extend ActionView::Helpers::TagHelper
extend ActionController::UrlWriter

Audit::TYPES.register :CREATE, Page do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " created " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
end

Audit::TYPES.register :UPDATE, Page do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " updated " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
end

Audit::TYPES.register :DESTROY, Page  do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " deleted #{event.auditable.title}"
end

Audit::TYPES.register :LOGIN, User do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " logged in"
end

Audit::TYPES.register :LOGOUT, User do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " logged out"
end