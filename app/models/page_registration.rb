class PageRegistration < Registration
  def self.register
    Audit::TYPES.register :CREATE, Page do |event|
      "#{event.user_link} created " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
    end

    Audit::TYPES.register :UPDATE, Page do |event|
      if event.auditable.status_id_changed?
        if event.auditable.status.name == "Published"
          "#{event.user_link} published " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
        else
        end
      else
        "#{event.user_link} updated " + link_to(event.auditable.title, "/admin/pages/#{event.auditable.id}")
      end
    end

    Audit::TYPES.register :DESTROY, Page  do |event|
      "#{event.user_link} deleted #{event.auditable.title}"
    end

    Audit::TYPES.register :LOGIN, User do |event|
      "#{event.user_link} logged in"
    end

    Audit::TYPES.register :LOGOUT, User do |event|
      "#{event.user_link} logged out"
    end
  end
end