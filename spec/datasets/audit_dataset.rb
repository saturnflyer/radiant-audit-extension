class AuditDataset < Dataset::Base
  uses :pages, :users
  include Auditor

  def load
    AuditEvent.destroy_all

    create_record :audit_type, :create, :name => "CREATE"
    create_record :audit_type, :update, :name => "UPDATE"
    create_record :audit_type, :destroy, :name => "DESTROY"
    create_record :audit_type, :login, :name => "LOGIN"
    create_record :audit_type, :logout, :name => "LOGOUT"
    
    create_record :audit_event, :auditable_type => 'Page', :auditable_id => page_id(:home), :user => users(:admin), :ip_address => '127.0.0.1',
                  :audit_type => audit_types(:create), :log_message => "Admin created homepage", :created_at => 1.hour.ago
    create_record :audit_event, :auditable_type => 'Page', :auditable_id => page_id(:home), :user => users(:admin), :ip_address => '192.168.0.0',
                  :audit_type => audit_types(:update), :log_message => "Admin updated homepage"

    create_record :audit_event, :first, :auditable_type => 'Page', :auditable_id => page_id(:home), :user => users(:existing), :ip_address => '192.168.0.0',
                  :audit_type => audit_types(:update), :log_message => "Existing updated homepage", :created_at => 5.days.ago
    create_record :audit_event, :second, :auditable_type => 'Page', :auditable_id => page_id(:home), :user => users(:existing), :ip_address => '192.168.0.0',
                  :audit_type => audit_types(:update), :log_message => "Existing updated homepage", :created_at => 3.days.ago
    create_record :audit_event, :third, :auditable_type => 'Page', :auditable_id => page_id(:home), :user => users(:existing), :ip_address => '192.168.0.0',
                  :audit_type => audit_types(:update), :log_message => "Existing updated homepage", :created_at => 1.days.ago
    
  end  
end