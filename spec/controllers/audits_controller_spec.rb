require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::AuditsController do
  dataset :audit

  describe "#scope_from_params" do
    it "should construct scope chain based on present params" do
      controller.params = {'user' => user_id(:admin), 'ip' => '127.0.0.1'}
      audits = controller.send(:scope_from_params)
      audits.should eql(AuditEvent.user(user_id(:admin)).ip('127.0.0.1').paginate(:page => 1, :order => "created_at desc"))
    end

    it "should respect order attribute" do
      controller.params = {'direction' => 'asc'}
      audits = controller.send(:scope_from_params)
      audits.should eql(AuditEvent.paginate(:page => 1, :order => "created_at asc"))
    end

    it "should discard blank params" do
      controller.params = {'user' => user_id(:admin), 'ip' => '', 'event_type' => ''}
      audits = controller.send(:scope_from_params)
      audits.should eql(AuditEvent.user(user_id(:admin)).paginate(:page => 1, :order => "created_at desc"))
    end
  end

  describe "#report" do
    before do
      login_as :admin
    end

    it "should build audits array based on scope from params" do
      get :report, :after => 1.day.ago
      assigns(:audits).should == AuditEvent.after(1.day.ago).paginate(:page => 1, :order => 'created_at desc')
    end

    it "should rescue a non-existent constant" do
      get :report, :auditable_id => 1, :auditable_type => 'Bogus'
      response.should be_success
    end

    it "should assign an @item based on auditable_type and auditable_id params" do
      get :report, :auditable_id => page_id(:home), :auditable_type => 'Page'
      assigns(:item).should eql(pages(:home))
    end
  end

  describe "#index" do
    before do
      login_as :admin
    end

    it "should build audits array based on date" do
      date = Date.today.to_s
      get :index, :date => date
      assigns(:audits).should == AuditEvent.date(date).paginate(:page => 1, :order => 'created_at asc')
    end
  end

end
