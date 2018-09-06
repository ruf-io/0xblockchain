require 'rails_helper'

RSpec.feature "Logout" do
  before do
    # Populate database using factory bot
    create :story
  end
  describe "Guest user" do
    scenario "Join then Logout" do
      # Perform authentication as user
      user = build :user
      # Stub is available at support/authentication_helper.rb
      stub_join_as user

      # On the homepge here, Then logout
      click_link "%s (0)" % user[:github_username]
      click_link "Logout"
      # Make sure it is redirected to the root path
      expect(page).to have_current_path root_path
      expect(page).to have_content "Login"
      expect(page).to have_content "You have successfully logged out!"
      expect(page).to have_content "Join via GitHub"
    end
  end

  describe "Existing user" do
    scenario "Login then Logout" do
      # Perform authentication as user
      user = create :user
      # Stub is available at support/authentication_helper.rb
      stub_login_as user

      # On the homepge here, Then logout
      click_link "%s (0)" % user[:github_username]
      click_link "Logout"
      # Make sure it is redirected to the root path
      expect(page).to have_current_path root_path
      expect(page).to have_content "Login"
      expect(page).to have_content "You have successfully logged out!"
      expect(page).to have_content "Join via GitHub"
    end
  end

  describe "Existing user (Admin)" do
    scenario "Login then Logout" do
      # Perform authentication as user
      user = create :user
      # Stub is available at support/authentication_helper.rb
      stub_login_as user

      # On the homepge here, Then logout
      click_link "%s (0)" % user[:github_username]
      click_link "Logout"
      # Make sure it is redirected to the root path
      expect(page).to have_current_path root_path
      expect(page).to have_content "Login"
      expect(page).to have_content "You have successfully logged out!"
      expect(page).to have_content "Join via GitHub"
    end
  end
end
