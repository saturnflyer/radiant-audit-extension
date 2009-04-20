class UserRegistration < Registration
  def self.register
    Audit::TYPES.register :CREATE, User do |event|
      "#{event.user_link} created " + link_to(event.auditable.name, "/admin/users/#{event.auditable.id}")
    end

    Audit::TYPES.register :UPDATE, User do |event|
      "#{event.user_link} updated " + link_to(event.auditable.name, "/admin/users/#{event.auditable.id}")
    end

    Audit::TYPES.register :DESTROY, User  do |event|
      "#{event.user_link} deleted #{event.auditable.name}"
    end
  end
end