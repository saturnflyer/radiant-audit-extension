class SnippetRegistration < Registration
  def self.register
    Audit::TYPES.register :CREATE, Snippet do |event|
      "#{event.user_link} created " + link_to(event.auditable.name, "/admin/snippets/#{event.auditable.id}")
    end

    Audit::TYPES.register :UPDATE, Snippet do |event|
      "#{event.user_link} updated " + link_to(event.auditable.name, "/admin/snippets/#{event.auditable.id}")
    end

    Audit::TYPES.register :DESTROY, Snippet  do |event|
      "#{event.user_link} deleted #{event.auditable.name}"
    end
  end
end