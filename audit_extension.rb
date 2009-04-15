# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class AuditExtension < Radiant::Extension
  version "1.0"
  description "Audit Extension- logs user actions in Radiant"
  url "http://digitalpulp.com"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :audit
  #   end
  # end
  
  def activate
    AuditObserver.instance
    ApplicationController.send :include, Audit::ApplicationExtensions
    Admin::WelcomeController.send :include, Audit::WelcomeControllerExtensions
    # admin.tabs.add "Audit", "/admin/audit", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Audit"
  end
  
end
