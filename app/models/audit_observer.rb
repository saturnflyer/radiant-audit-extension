class AuditObserver < ActiveRecord::Observer
  include Auditor
  observe AuditExtension::OBSERVABLES
  
  cattr_accessor :current_user
  cattr_accessor :current_ip
  
  def after_create(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => Audit::TYPES::CREATE
  end

  def after_update(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => Audit::TYPES::UPDATE
  end
  
  def after_destroy(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => Audit::TYPES::DESTROY
  end

end