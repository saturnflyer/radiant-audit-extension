require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AuditsHelper do
  attr_accessor :params
  include Admin::AuditsHelper
  
  before do
    @params = HashWithIndifferentAccess.new
  end

  describe "#reverse_direction" do
    it "should default to asc" do
      reverse_direction.should eql('asc')
    end

    it "should be asc when param = desc" do
      @params = {:direction => 'desc'}
      reverse_direction.should eql('asc')
    end

    it "should be desc when param = asc" do
      @params = {:direction => 'asc'}
      reverse_direction.should eql('desc')
    end
  end

  describe "#browse_by_date_filters_set?" do
    it "should be false" do
      browse_by_date_filters_set?.should be_false
    end

    it "should be true when any date filter is set" do
      @params = { :ip => '127.0.0.1'}
      browse_by_date_filters_set?.should be_true
    end
  end

  describe "#custom_report_filters_set?" do
    it "should be false" do
      custom_report_filters_set?.should be_false
    end

    it "should be true when any report filter is set" do
      @params = { :before => Time.now }
      custom_report_filters_set?.should be_true
    end
  end
end