require 'rails_helper'

RSpec.feature "Login with github" do
  scenario "Guest user (Previously not exists in the database) via homepage" do
    # Test data
    github_uid = "1234"
    github_username = "test"
    github_email = "test@email.com"
    github_oauth_token = "1234"

    # Go to homepage
    visit "/"
    expect(page).to have_content "Login"
    expect(page).to have_content "Join via GitHub"

    # First, create the dummy user
    # user = User.new
    # user.github_uid = "1234"
    # user.username = "test"

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

    # Test the response
    expect(page).to_not have_content "Login"
    expect(page).to_not have_content "Join via GitHub"
    expect(page).to have_content github_username
    expect(page).to have_current_path("/")
  end

  scenario "Existing user via homepage" do
    # Test data
    github_uid = "1234"
    github_username = "test"
    github_email = "test@email.com"
    github_oauth_token = "1234"

    User.create(
      username: github_username,
      email: github_email,
      github_uid: github_uid,
      github_oauth_token: github_oauth_token
    )

    # Go to homepage
    visit "/"
    expect(page).to have_content "Login"
    # Perform authentication
    click_link "Login"

    # Test the response
    expect(page).to_not have_content "Login"
    expect(page).to_not have_content "Join via GitHub"
    expect(page).to have_content github_username
    expect(page).to have_current_path("/")
  end
end
