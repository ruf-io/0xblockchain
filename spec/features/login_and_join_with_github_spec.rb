require 'rails_helper'

RSpec.feature "Login & Join with github" do
  before do
    # Populate database using factory bot
    create :story
  end

  describe "Guest user" do
    scenario "Join via github" do
      # Perform authentication as user
      user = build :user
      # Stub is available at support/authentication_helper.rb
      stub_join_as user

      # Test the response
      # test homepage
      expect(page).to have_current_path root_path
      expect(page).to_not have_content "Login"
      expect(page).to_not have_content "Join via GitHub"
      expect(page).to have_content user[:github_username]
    end
  end

  describe "Existing user (Non-admin)" do
    scenario "Login via github" do
      # Perform authentication as user
      user = create :user
      # Stub is available at support/authentication_helper.rb
      stub_login_as user

      # Test the response
      # test homepage
      expect(page).to have_current_path root_path
      expect(page).to_not have_content "Login"
      expect(page).to_not have_content "Join via GitHub"
      expect(page).to have_content user[:github_username]
    end
  end

  describe "Existing user (Admin)" do
    scenario "Login via github" do
      # Perform authentication as user
      user = create :user, is_admin: true
      # Stub is available at support/authentication_helper.rb
      stub_login_as user

      # Test the response
      # test homepage
      expect(page).to have_current_path root_path
      expect(page).to_not have_content "Login"
      expect(page).to_not have_content "Join via GitHub"
      expect(page).to have_content user[:github_username]
    end
  end
end
