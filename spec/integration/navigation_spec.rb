require 'spec_helper'

describe "Navigation" do
  include Capybara

  it "should be a valid app" do
    visit "/"
    page.should have_content("You found me")
  end
end
