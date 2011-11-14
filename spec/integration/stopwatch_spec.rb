require 'spec_helper'

describe "Navigation" do
  include Capybara::DSL

  it "renders the stopwatch box" do
    visit "/"
    page.should have_css("#performance_code")
  end

  it "does not insert html" do
    visit "/javascript_test"
    page.should_not have_css("#performance_code")
  end
end
