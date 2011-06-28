require 'spec_helper'

describe "Navigation" do
  include Capybara

  it "renders the stopwatch box" do
    visit "/"
    page.should have_css("#performance_code")
  end
end
