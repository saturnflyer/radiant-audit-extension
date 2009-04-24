require File.dirname(__FILE__) + '/../spec_helper'

describe AuditObserver do
  Audit.disable_logging do
    dataset :users, :pages_with_layouts, :snippets
  end

  before(:each) do
    @user = users(:existing)
    AuditObserver.current_user = @user
  end

  describe "Page logging" do
    it "should log create" do
      count = AuditEvent.count
      Page.create!(page_params)
      AuditEvent.count.should == count+1
    end
    
    it "should log update" do
      count = AuditEvent.count
      page = pages(:home)
      page.attributes = page.attributes
      page.save.should == true
      AuditEvent.count.should == count+1
    end
    
    it "should log destroy" do
      count = AuditEvent.count
      page = pages(:home)
      page.destroy
      AuditEvent.count.should > count
    end
  end

  describe "User logging" do
    it "should log create" do
      count = AuditEvent.count
      User.create!(user_params)
      AuditEvent.count.should == count+1
    end
    
    it "should log update" do
      count = AuditEvent.count
      user = users(:existing)
      user.attributes = user.attributes
      user.save.should == true
      AuditEvent.count.should == count+1
    end
    
    it "should log destroy" do
      count = AuditEvent.count
      user = users(:existing)
      user.destroy
      AuditEvent.count.should == count+1
    end
  end

  describe "Layout logging" do
    it "should log create" do
      count = AuditEvent.count
      Layout.create!(layout_params)
      AuditEvent.count.should == count+1
    end
    
    it "should log update" do
      count = AuditEvent.count
      layout = layouts(:main)
      layout.attributes = layout.attributes
      layout.save.should == true
      AuditEvent.count.should == count+1
    end
    
    it "should log destroy" do
      count = AuditEvent.count
      layout = layouts(:main)
      layout.destroy
      AuditEvent.count.should == count+1
    end
  end

  describe "Snippet logging" do
    it "should log create" do
      count = AuditEvent.count
      Snippet.create!(snippet_params)
      AuditEvent.count.should == count+1
    end
    
    it "should log update" do
      count = AuditEvent.count
      snippet = snippets(:first)
      snippet.attributes = snippet.attributes
      snippet.save.should == true
      AuditEvent.count.should == count+1
    end
    
    it "should log destroy" do
      count = AuditEvent.count
      snippet = snippets(:first)
      snippet.destroy
      AuditEvent.count.should == count+1
    end
  end

end
