# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class AuditExtension < Radiant::Extension
  version "1.0"
  description "Audit Extension- logs user actions in Radiant"
  url "http://digitalpulp.com"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :audits
      admin.audits_report '/admin/audits/report', :controller => "audits", :action => "report"
    end
  end
  
  OBSERVABLES = [User, Page, Layout, Snippet]
  
  def activate
    AuditEvent
    Audit.disable_logging unless ActiveRecord::Base.connection.tables.include?(AuditType.table_name)
    ApplicationController.send :include, Audit::ApplicationExtensions
    Admin::WelcomeController.send :include, Audit::WelcomeControllerExtensions
    Page.send :include, Audit::PageExtensions
    User.send :include, Audit::UserExtensions
    Snippet.send :include, Audit::SnippetExtensions
    Layout.send :include, Audit::LayoutExtensions

    AuditObserver.instance

    admin.tabs.add "Audit", "/admin/audits", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Audit"
  end
  
end
