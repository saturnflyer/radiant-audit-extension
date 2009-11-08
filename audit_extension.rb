# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class AuditExtension < Radiant::Extension
  version "0.9"
  description "Audit Extension- logs user actions in Radiant"
  url "http://digitalpulp.com"
  
  extension_config do |ext|
    ext.gem "will_paginate"
  end
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :audits
    end
  end
  
  DATE_TIME_FORMATS = {
    :iso8601     => '%F',
    :mdy_time    => '%m/%d/%Y %I:%M %p',
    :mdy_time_tz => '%m/%d/%Y %I:%M %p %Z',
    :mdy_short   => '%m/%d/%y'
  }
  
  ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(AuditExtension::DATE_TIME_FORMATS)
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(AuditExtension::DATE_TIME_FORMATS)
  
  OBSERVABLES = [User, Page, Layout, Snippet]
  
  def activate
    require "audit"
    AuditEvent
    Audit.disable_logging unless ActiveRecord::Base.connection.tables.include?(AuditType.table_name)
    [ApplicationController, *ApplicationController.subclasses.map(&:constantize)].each { |c| c.send :include, Audit::ApplicationExtensions }
    Admin::WelcomeController.send :include, Audit::WelcomeControllerExtensions
    Page.send :include, Audit::PageExtensions
    User.send :include, Audit::UserExtensions
    Snippet.send :include, Audit::SnippetExtensions
    Layout.send :include, Audit::LayoutExtensions

    AuditObserver.instance
    

    admin.nav << Radiant::AdminUI::NavTab.new(:tools, "Tools") unless admin.nav[:tools]
    admin.nav[:tools] << admin.nav_item("Audit Log", "Audit Log", "/admin/audits")
  end
  
  def deactivate
    # admin.tabs.remove "Audit"
  end
  
end
