class LayoutRegistration < Registration
  def self.register
    Audit::TYPES.register :CREATE, Layout do |event|
      "#{event.user_link} created " + link_to(event.auditable.name, "/admin/layouts/#{event.auditable.id}")
    end

    Audit::TYPES.register :UPDATE, Layout do |event|
      "#{event.user_link} updated " + link_to(event.auditable.name, "/admin/layouts/#{event.auditable.id}")
    end

    Audit::TYPES.register :DESTROY, Layout  do |event|
      "#{event.user_link} deleted #{event.auditable.name}"
    end
  end
end