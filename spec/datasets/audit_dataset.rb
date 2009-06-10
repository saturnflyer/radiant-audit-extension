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
    
    create_record :audit_event, :auditable => pages(:home), :user => users(:admin), :ip_address => '127.0.0.1', 
                                :audit_type => audit_types(:create), :log_message => "Admin created homepage", :created_at => 1.hour.ago
    create_record :audit_event, :auditable => pages(:home), :user => users(:admin), :ip_address => '192.168.0.0', 
                  :audit_type => audit_types(:update), :log_message => "Admin updated homepage"
  end  
end