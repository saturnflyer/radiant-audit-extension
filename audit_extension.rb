# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class AuditExtension < Radiant::Extension
  version "1.0"
  description "Audit Extension- logs user actions in Radiant"
  url "http://digitalpulp.com"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :audits
    end
  end
  
  OBSERVABLES = [User, Page, Layout, Snippet]
  
  def activate
    AuditObserver.instance
    ApplicationController.send :include, Audit::ApplicationExtensions
    Admin::WelcomeController.send :include, Audit::WelcomeControllerExtensions
    User.send :include, Audit::UserExtensions

    Dir.glob(File.join(AuditExtension.root, %w(app models), '*_registration.rb')).each { |f| require_dependency f }

    admin.tabs.add "Audit", "/admin/audits", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Audit"
  end
  
end
