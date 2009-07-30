require File.dirname(__FILE__) + '/../spec_helper'

describe Audit::PageExtensions do
  dataset :audit
  describe "#updated_fields" do
    it "should list any changed page parts" do
      page = pages(:home)
      part = page.part('sidebar')
      part.content = 'New content'
      page.title = 'New title'
      Page.updated_fields(['title'], page).should include('sidebar')
    end
  end
end