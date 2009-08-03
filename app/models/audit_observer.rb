class AuditObserver < ActiveRecord::Observer
  include Auditor
  observe AuditExtension::OBSERVABLES
  
  cattr_accessor :current_user
  cattr_accessor :current_ip
  
  def after_create(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => :create
  end

  def before_update(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => :update
  end
  
  def after_destroy(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => :destroy
  end

end