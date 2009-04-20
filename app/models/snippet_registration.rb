class SnippetRegistration < Audit::Registration
  audits Snippet

  register :CREATE do |event|
    "#{event.user_link} created " + link_to(event.auditable.name, "/admin/snippets/#{event.auditable.id}")
  end

  register :UPDATE do |event|
    "#{event.user_link} updated " + link_to(event.auditable.name, "/admin/snippets/#{event.auditable.id}")
  end

  register :DESTROY do |event|
    "#{event.user_link} deleted #{event.auditable.name}"
  end
end