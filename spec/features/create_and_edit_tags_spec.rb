require 'rails_helper'

def stub_login_as_nonadmin_user
  github_uid = "1234"
  github_username = "test"
  github_email = "test@email.com"
  github_oauth_token = "1234"

  # first, set OmniAuth to run in test mode
  OmniAuth.config.test_mode = true
  # then, provide a set of fake oauth data that
  # omniauth will use when a user tries to authenticate:
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    :provider => "github",
    :uid => github_uid,
    :info => { :email => github_email, :nickname => github_username },
    :credentials => { :token => github_oauth_token }
  )

  # Perform authentication
  click_link "Login"
end

def stub_login_as_admin_user
  github_uid = "1234admin"
  github_username = "test_admin"
  github_email = "test_admin@email.com"
  github_oauth_token = "1234admin"

  User.create(
    username: github_username,
    email: github_email,
    github_oauth_token: github_oauth_token,
    github_uid: github_uid,
    is_admin: true
  )

  # first, set OmniAuth to run in test mode
  OmniAuth.config.test_mode = true
  # then, provide a set of fake oauth data that
  # omniauth will use when a user tries to authenticate:
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    :provider => "github",
    :uid => github_uid,
    :info => { :email => github_email, :nickname => github_username },
    :credentials => { :token => github_oauth_token }
  )

  # Perform authentication
  visit root_path
  click_link "Login"
end

def stub_login_as_nonadmin_user
  github_uid = "1234"
  github_username = "test"
  github_email = "test@email.com"
  github_oauth_token = "1234"

  # first, set OmniAuth to run in test mode
  OmniAuth.config.test_mode = true
  # then, provide a set of fake oauth data that
  # omniauth will use when a user tries to authenticate:
  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
    :provider => "github",
    :uid => github_uid,
    :info => { :email => github_email, :nickname => github_username },
    :credentials => { :token => github_oauth_token }
  )

  # Perform authentication
  visit root_path
  click_link "Login"
end

RSpec.feature "Create and edit tags" do
  describe "Guest user" do
    it "should not be able to see 'create new tag' and 'edit' link" do
      # Go to tags page
      visit tags_path

      # Test the response
      expect(page).to_not have_content "Edit"
      expect(page).to_not have_content "Create New Tag"
    end
  end

  describe "Non-admin user" do
    before do
      stub_login_as_nonadmin_user
    end

    it "should not be able to see 'create new tag' and 'edit' link" do
      # Go to tags page
      visit tags_path

      # Test the response
      expect(page).to_not have_content "Edit"
      expect(page).to_not have_content "Create New Tag"
    end
  end

  describe "Admin user" do
    before do
      stub_login_as_admin_user
    end

    it "should be able to see 'create new tag' and 'edit' link" do
      # Go to tags page
      visit tags_path

      # Test the response
      expect(page).to have_content "Edit"
      expect(page).to have_content "Create new tag"
    end

    scenario "admin user create tag with blank name" do
      # Go to tags page
      visit tags_path

      # Click the new tag button
      click_link "Create new tag"

      # Don't fill the form, just submit the content
      click_button "Create tag"

      # It should display an error
      expect(page).to have_content "New tag not created: Tag can't be blank"
    end

    scenario "admin user create 'test' tag" do
      # Go to tags page
      visit tags_path

      # Click the new tag button
      click_link "Create new tag"

      # fill the form and submit the content
      fill_in "tag[tag]", with: "test"
      fill_in "tag[description]", with: "Some tag description"
      click_button "Create tag"

      # It should redirected to tag path and display success message
      expect(page).to have_current_path tags_path
      expect(page).to have_content "Tag \"test\" has been created"
      expect(page).to have_content "Some tag description"
    end

    scenario "admin user update 'test2' tag" do
      # Create the tag first with empty description
      tag = Tag.create(tag: "test2")

      # Go to tags page
      visit tags_path
      expect(page).to_not have_content "Some tag update description"

      # Click the edit link
      find("a.tag-%s" % tag.id).click

      # fill the form and submit the content
      fill_in "tag[description]", with: "Some tag update description"
      click_button "Update tag"

      # It should redirected to tag path and display success message
      expect(page).to have_current_path tags_path
      expect(page).to have_content "Tag \"test2\" has been updated"
      expect(page).to have_content "Some tag update description"
    end
  end
end
