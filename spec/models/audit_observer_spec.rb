require File.dirname(__FILE__) + '/../spec_helper'

describe AuditObserver do
  dataset :users, :pages_with_layouts, :snippets

  before(:each) do
    @user = users(:existing)
    AuditObserver.current_user = @user
  end

  describe "Page logging" do
    it "should log create" do
      lambda {
        page = Page.create(:title => 'title', :slug => 'slug', :breadcrumb => 'breadcrumb')
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        pages(:home).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      page = Page.create(:title => 'title', :slug => 'slug', :breadcrumb => 'breadcrumb')
      lambda {
        page.destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

  describe "User logging" do
    it "should log create" do
      lambda {
        User.create!(user_params)
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        users(:existing).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      lambda {
        users(:existing).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

  describe "Layout logging" do
    it "should log create" do
      lambda {
        Layout.create!(layout_params)
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        layouts(:main).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      lambda {
        layouts(:main).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

  describe "Snippet logging" do
    it "should log create" do
      lambda {
        Snippet.create!(snippet_params)
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log update" do
      lambda {
        snippets(:first).save
      }.should change(AuditEvent, :count).by(1)
    end
    
    it "should log destroy" do
      lambda {
        snippets(:first).destroy
      }.should change(AuditEvent, :count).by(1)
    end
  end

end
