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
  end

  describe "#report" do
    it "should build audits array based on scope from params"
  end

end
