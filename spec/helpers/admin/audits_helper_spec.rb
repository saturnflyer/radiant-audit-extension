require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AuditsHelper do
  dataset :pages
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

  describe "#filters_set?" do
    it "should be false" do
      filters_set?.should be_false
    end

    it "should be true when any date filter is set" do
      @params = { :ip => '127.0.0.1'}
      filters_set?.should be_true
    end
  end

  describe "item_link" do
    it "should be empty if @item is not assigned" do
      item_link.should be_blank
    end

    it "should be a page link if @item is a page" do
      @item = pages(:first)
      item_link.should =~ /a href=".+"/
      item_link.should =~ /#{@item.title}/
    end

    it "should not be linked if @item is of an unknown class" do
      @item = String.new
      item_link.should be_blank
    end

    it "should say (deleted) if object does not exist but we have logs" do
      @params = { :auditable_type => 'Page', :auditable_id => page_id(:first) }
      pages(:first).destroy
      item_link.should == "Page ##{page_id(:first)} (deleted)"
    end
  end
end