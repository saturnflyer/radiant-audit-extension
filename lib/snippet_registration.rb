extend ActionView::Helpers::UrlHelper
extend ActionController::PolymorphicRoutes
extend ActionView::Helpers::TagHelper
extend ActionController::UrlWriter

Audit::TYPES.register :CREATE, Snippet do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " created " + link_to(event.auditable.name, "/admin/snippets/#{event.auditable.id}")
end

Audit::TYPES.register :UPDATE, Snippet do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " updated " + link_to(event.auditable.name, "/admin/snippets/#{event.auditable.id}")
end

Audit::TYPES.register :DESTROY, Snippet  do |event|
  link_to("#{event.user.name}", "/admin/users/#{event.user.id}") + " deleted #{event.auditable.name}"
end
