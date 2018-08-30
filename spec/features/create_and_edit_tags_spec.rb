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
  scenario "Guest user should not be able to see 'create new tag' and 'edit' link" do
    # Go to tags page
    visit tags_path

    # Test the response
    expect(page).to_not have_content "Edit"
    expect(page).to_not have_content "Create New Tag"
  end

  scenario "Non-admin user should not be able to see 'create new tag' and 'edit' link" do
    stub_login_as_nonadmin_user

    # Go to tags page
    visit tags_path

    # Test the response
    expect(page).to_not have_content "Edit"
    expect(page).to_not have_content "Create New Tag"
  end

  scenario "Admin user should be able to see 'create new tag' and 'edit' link" do
    stub_login_as_admin_user

    # Go to tags page
    visit tags_path

    # Test the response
    expect(page).to have_content "Edit"
    expect(page).to have_content "Create New Tag"
  end
end
