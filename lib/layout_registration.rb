extend ActionView::Helpers::UrlHelper
extend ActionController::PolymorphicRoutes
extend ActionView::Helpers::TagHelper
extend ActionController::UrlWriter

Audit::TYPES.register :CREATE, Layout do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " created " + link_to(event.auditable.name, "/admin/layouts/#{event.auditable.id}")
end

Audit::TYPES.register :UPDATE, Layout do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " updated " + link_to(event.auditable.name, "/admin/layouts/#{event.auditable.id}")
end

Audit::TYPES.register :DESTROY, Layout  do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " deleted #{event.auditable.name}"
end
