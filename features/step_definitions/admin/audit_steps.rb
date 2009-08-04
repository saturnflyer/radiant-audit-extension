When /^I go to the audit report for page "([^\"]*)"$/ do |page|
  visit report_admin_audits_path :auditable_type => 'Page', :auditable_id => page_id(page.underscore.to_sym)
end

Then /^I should see a link to edit page "([^\"]*)"$/ do |page|
  response.body.should include(edit_admin_page_path page_id(page.underscore.to_sym))
end

Then /^I should not see a link to edit page "([^\"]*)"$/ do |page|
  response.body.should_not include(edit_admin_page_path page_id(page.underscore.to_sym))
end


Given /^I delete page "([^\"]*)"$/ do |page|
  visit remove_admin_page_path(page_id(page.underscore.to_sym))
  click_button "Delete Pages"
end
