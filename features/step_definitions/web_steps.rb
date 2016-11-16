# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.


require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator, :match => :prefer_exact) { yield } : yield
  end
end
World(WithinHelpers)

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^\"]*)"(?: within "([^\"]*)")?$/ do |button, selector|
  button = 'close_modal' if button.eql? "Close Modal"
  with_scope(selector) do
    click_button(button, :match => :prefer_exact)
    # To fix ambiguity with Capybara 2 let's take just the first match
    # first(:button, button).click
  end
end

When /^(?:|I )return to "([^\"]*)"(?: within "([^\"]*)")?$/ do |link, selector| # Simple replacement of "return to" for "follow", seen below
  with_scope(selector) do
    click_link(link, :match => :prefer_exact)
    # first(:link, link).click
  end
end

When /^(?:|I )follow "([^\"]*)" within the top navbar$/ do |link|
  with_scope("#terraling-navbar-collapse") do
    # hover over correct element
    find("ul.nav:nth-child(1) > li:nth-child(1) > a:nth-child(1)").hover
    click_link(link, :match => :prefer_exact)
    # To fix ambiguity with Capybara let's take just the first match
    # first(:link, link).click
  end
end

When /^(?:|I )follow "([^\"]*)"(?: within "([^\"]*)")?$/ do |link, selector|
  with_scope(selector) do
    link = "saveit" if link.eql? "Save Search"
    if link.eql? "Download Results"
      clear_directory(download_dir)
      link = "downloadit"
    end
    # This step is too general and ambiguious, might have to break apart
    if link.eql? "Syntactic Structures" && page.has_link?(:text => "Pick a Dataset")
      find('a', :text =>"Pick a Dataset").hover
    end
    if link.eql? "Members"
      link = "All Members"
      find('a', :text =>"Contributors").hover
    end
    if link.eql? "public groups"
      # Have to scroll using javascript due to banner
      page.execute_script "document.querySelector('#main > div:nth-child(3) > div:nth-child(3) > div:nth-child(1) > p:nth-child(2) > a:nth-child(1)').scrollIntoView()"
      page.execute_script "window.scrollBy(0,-100)"
    end
    find('a', :text =>"Search").hover if link.eql?( "Advanced Search" )|| link.eql?( "History")
    find('li#userInfo').hover if link.eql? "Sign out"

    click_link(link, :match => :prefer_exact)

    # To fix ambiguity with Capybara let's take just the first match
    # first(:link, link).click

    #accept 'are you sure?' pop up
    accept_alert_popup if link.eql? "Delete"
  end
end

When /^(?:|I )fill in "([^\"]*)" with "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value, :match => :prefer_exact)
    # first(:field, field).set value
  end
end

# When I search in the "#auto_compare" field with "s"
When /^(?:|I )search in the "([^\"]*)" field with "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, value, selector|
  with_scope(selector) do
    fill_in(field, :with => value, :match => :prefer_exact)
    # first(:field, field).set value
    # See Issue #43 in Poltergeist
    page.execute_script "$('\##{field}').keydown()"
  end
end

Then /^(?:|I )should see "([^\"]*)" in the "([^\"]*)"$/ do |text, field|
  # Focus to the autocomplete
  page.execute_script "$('#{field}').focus()"
  # search for the text
  with_scope(".typeahead") do
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

# Then I add "Spanish" to the list
When /^(?:|I )add "([^\"]*)"(?: within "([^\"]*)")? to the list$/ do |link, selector|
  selector |= ".typeahead"
  with_scope(selector) do
    click_link(link, :match => :prefer_exact)
    # To fix ambiguity with Capybara let's take just the first match
    # first(:link, link).click
  end
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When /^(?:|I )fill in the following(?: within "([^\"]*)")?:$/ do |selector, fields|
  with_scope(selector) do
    fields.rows_hash.each do |name, value|
      When %{I fill in "#{name}" with "#{value}"}
    end
  end
end

When /^(?:|I )select "([^\"]*)" from "([^\"]*)"(?: within "([^\"]*)")?$/ do |value, field, selector|
  # Another UI change.. might have to change in tests
  field = "Action" if field.eql? "Perform"
  with_scope(selector) do
    unselect("Adjective Noun", :from => field, :match => :prefer_exact) if field == "prop-select"
    select(value, :from => field, :match => :prefer_exact)
    # find(:input, field).set(value)
    # find_field(field).select(value)
  end
end

When /^(?:|I )check "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    check(field, :match => :prefer_exact)
    # find(:checkbox, field).first.set(true)
  end
end

When /^(?:|I )uncheck "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  with_scope(selector) do
    uncheck(field, :match => :prefer_exact)
    # find(:checkbox, field).set(false)
  end
end

When /^(?:|I )choose "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  choose_field(selector, field)
end

When /^(?:|I )choose Implication "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, selector|
  field = "search_group_impl_#{field.downcase}"
  choose_field(selector, field)
end

When /^(?:|I )attach the file "([^\"]*)" to "([^\"]*)"(?: within "([^\"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, path)
  end
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  expected.should == actual
end

Then /^(?:|I )should see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then /^(?:|I )should see "([^\"]*)" within the top navbar$/ do |text|
  with_scope("#terraling-navbar-collapse") do
    # Hover over correct element
    find("ul.nav:nth-child(1) > li:nth-child(1) > a:nth-child(1)").hover
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then /^I should see the "([^\"]*)" draw$/ do |selector|
  if page.respond_to? :should
    page.should have_selector("\##{selector.underscore}")
  else
    assert page.has_selector?("\##{selector.underscore}")
  end
end


Then /^(?:|I )should see "([^\"]*)" in common?$/ do |text|
  with_scope("#tableCommon") do
    if page.respond_to? :should
      page.should have_content(text)
    else
      assert page.has_content?(text)
    end
  end
end

Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^\"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

Then /^(?:|I )should not see "([^\"]*)"(?: within "([^\"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_content(text)
    else
      assert page.has_no_content?(text)
    end
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^\"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end

Then /^the "([^\"]*)" field(?: within "([^\"]*)")? should contain "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^\"]*)" field(?: within "([^\"]*)")? should not contain "([^\"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^\"]*)" checkbox(?: within "([^\"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the "([^\"]*)" checkbox(?: within "([^\"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')}

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^I should see "([^\"]*)" button/ do |name|
  find_button(name).should_not be_nil
end

Then /^I wait "([^\"]*)"$/ do |num|
  sleep(num.to_i)
end

When /^I access the new tab and should see "([^\"]*)"$/ do |regexp|
  # page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  sleep(2)
  opened = page.driver.window_handles.last
  page.within_window opened do
    regexp = Regexp.new(regexp)
    if page.respond_to? :should
      page.should have_xpath('//*', :text => regexp)
    else
      assert page.has_xpath?('//*', :text => regexp)
    end
  end
end

When /^I access the first tab$/ do
  page.driver.browser.switch_to.window(page.driver.browser.window_handles.first)
end

Then /^a new window (.+) will open$/ do |page_title|
  sleep(3)
  opened = page.driver.window_handles.last
  p "#{page.driver.window_handles.inspect}"
  if page.respond_to? :should
      opened.should have_title(page_title)
    else
      assert opened.has_title?(page_title)
    end
end

Then /^(?:|I )see this page$/ do
  page.save_screenshot("./page.png", :full => true)
end

Then /^(?:|I )see the Javascript console$/ do
  page.driver.debug
end

Then /^(?:|I )want at most "([^\"]*)" results per page$/ do |rows|
  rows_per_page(rows.to_i)
end

Then /^I hover over my user info$/ do
  find_by_id("userInfo").hover
end
