require 'rails_helper'

RSpec.feature "Disallow web crawler" do
  before do
    ENV["DISALLOW_ALL_WEB_CRAWLERS"] = "true"
    ENV["BASIC_AUTH_USERNAME"] = "test"
    ENV["BASIC_AUTH_PASSWORD"] = "test"
  end

  scenario "DISALLOW_ALL_WEB_CRAWLERS is set" do
    # ClimateControl.modify DISALLOW_ALL_WEB_CRAWLERS: "true" do
    expect(ENV["DISALLOW_ALL_WEB_CRAWLERS"]).to_not be_nil

    # Make sure all public routes are protected
    visit root_path
    expect(page.status_code).to eql 401
    visit tags_path
    expect(page.status_code).to eql 401
    visit comments_path
    expect(page.status_code).to eql 401
  end
end
