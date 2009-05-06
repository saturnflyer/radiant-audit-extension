class AuditObserver < ActiveRecord::Observer
  include Auditor
  observe AuditExtension::OBSERVABLES
  
  cattr_accessor :current_user
  cattr_accessor :current_ip
  
  def after_create(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => :create
  end

  def after_update(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => :update

    # allow an audit event to be chained on after the update event fires.
    # define the OBSERVABLE_FIELDS you want to create custom AuditEvent messages for in your class
    # (see page_extensions for an example) and the appropriate audit_event.
    if defined?(model.class::OBSERVABLE_FIELDS) && model.class::OBSERVABLE_FIELDS.any?
      model.class::OBSERVABLE_FIELDS.each do |field|
        # check to see if the field you're interested in has changed using ActiveRecord's dirty methods
        if model.send "#{field.to_s}_changed?"
          # gsub out '_id' in the field to make the log message prettier (i.e. Status Changed vs Status ID Changed)
          audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => "#{field.to_s.gsub(/_id$/, '')}_change".to_sym
        end
      end
    end

  end
  
  def after_destroy(model)
    audit :item => model, :user => @@current_user, :ip => @@current_ip, :type => :destroy
  end

end