module AuthenticationHelper
  # Stub login as existing user
  def stub_login_as user
    # first, set OmniAuth to run in test mode
    OmniAuth.config.test_mode = true
    # then, provide a set of fake oauth data that
    # omniauth will use when a user tries to authenticate:
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      :provider => "github",
      :uid => user[:github_uid],
      :info => {
        :email => user[:github_email],
        :nickname => user[:github_username],
      },
      :credentials => { :token => user[:github_oauth_token] }
    )

    User.create(
      username: user[:github_username],
      email: user[:github_email],
      github_oauth_token: user[:github_oauth_token],
      github_uid: user[:github_uid],
      is_admin: user[:is_admin]
    )

    # Visit HomePage and Perform authentication
    visit root_path
    click_link "Login"
  end

  # Stub Join as new user
  def stub_join_as user
    # first, set OmniAuth to run in test mode
    OmniAuth.config.test_mode = true
    # then, provide a set of fake oauth data that
    # omniauth will use when a user tries to authenticate:

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      :provider => "github",
      :uid => user[:github_uid],
      :info => {
        :email => user[:github_email],
        :nickname => user[:github_username],
      },
      :credentials => { :token => user[:github_oauth_token] }
    )

    # Visit HomePage and Perform authentication
    visit root_path
    click_link "Join via GitHub"
  end
end
