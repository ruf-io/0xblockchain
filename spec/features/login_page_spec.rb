require 'rails_helper'

RSpec.feature "Login page" do
  describe "Guest user" do
    scenario "Access the page" do
      visit login_path
      expect(page).to have_current_path login_path
      expect(page).to have_content "Login"
      expect(page).to have_content "Join via GitHub"
      expect(page).to have_content "You must be logged in to continue."
    end
  end

  describe "Authenticated user" do
    scenario "Login then access the page" do
      # Perform authentication as user
      user = create :user
      # Stub is available at support/authentication_helper.rb
      stub_login_as user

      # Access /login
      visit login_path

      # Make sure it is redirected to home page
      expect(page).to have_current_path root_path
      expect(page).to_not have_content "You must be logged in to continue."
    end
  end
end
