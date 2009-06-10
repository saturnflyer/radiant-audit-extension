require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::AuditsController do
  dataset :audit

  describe "#scope_from_params" do
    it "should construct scope chain based on present params" do
      params = {'user' => user_id(:admin), 'ip' => '127.0.0.1'}
      audits = controller.send(:scope_from_params, params)
      audits.should eql(AuditEvent.user(user_id(:admin)).ip('127.0.0.1').paginate(:page => 1, :order => "created_at desc"))
    end

    it "should respect order attribute" do
      params = {'direction' => 'asc'}
      audits = controller.send(:scope_from_params, params)
      audits.should eql(AuditEvent.paginate(:page => 1, :order => "created_at asc"))
    end

    it "should discard blank params" do
      params = {'user' => user_id(:admin), 'ip' => '', 'event_type' => ''}
      audits = controller.send(:scope_from_params, params)
      audits.should eql(AuditEvent.user(user_id(:admin)).paginate(:page => 1, :order => "created_at desc"))
    end
  end

  describe "#report" do
    before do
      login_as :admin
    end

    it "should build audits array based on scope from params" do
      get :report, :after => 30.minutes.ago
      assigns(:audits).should eql(AuditEvent.after(30.minutes.ago).paginate(:page => 1))
    end
  end

  describe "#index" do
    before do
      login_as :admin
    end

    it "should build audits array based on date" do
      date = Date.today.to_s
      get :index, :after => date, :before => date
      assigns(:audits).should eql(AuditEvent.on(date).paginate(:page => 1))
    end
  end

end
