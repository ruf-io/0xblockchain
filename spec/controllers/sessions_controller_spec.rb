require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  # Test data
  github_uid = "1234"
  github_username = "test"
  github_email = "test@email.com"
  github_oauth_token = "1234"

  before do
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
      :provider => "github",
      :uid => github_uid,
      :info => { :email => github_email, :nickname => github_username },
      :credentials => { :token => github_oauth_token }
    )
  end

  describe "#create" do
    it "should successfully create a user & session" do
      # Post the data
      post :create

      # Make sure user are created
      user = User.find_by!(github_uid: github_uid)
      expect(user.username).to eq github_username
      expect(user.email).to eq github_email
      expect(user.github_uid).to eq github_uid
      expect(user.github_oauth_token).to eq github_oauth_token

      # Make sure session are created
      expect(session[:u]).to eq user.session_token
    end

    it "should redirect the user to the origin url" do
      # Set origin to nil
      request.env['omniauth.origin'] = nil
      # Perform post request
      post :create
      expect(response).to redirect_to "/"

      # Set origin to "/recent"
      request.env['omniauth.origin'] = "/recent"
      # Perform post request
      post :create
      expect(response).to redirect_to "/recent"
    end

    it "should raise LoginBannedError if user is banned" do
      # Create new user with banned status
      banned_uid = "1234_banned"
      banned_username = "test_banned"
      banned_email = "test@email_banned.com"
      banned_oauth_token = "1234"
      User.create(
        username: banned_username,
        email: banned_email,
        github_uid: banned_uid,
        github_oauth_token: banned_oauth_token,
        banned_at: Time.current
      )

      # Login with banned user
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        :provider => "github",
        :uid => banned_uid,
        :info => { :email => banned_email, :nickname => banned_username },
        :credentials => { :token => banned_oauth_token }
      )
      post :create
      expect(flash[:error]).to eq "Your account has been banned."
    end
    it "should raise LoginDeletedError if user is deleted" do
      # Create new user with deleted status
      deleted_uid = "1234_deleted"
      deleted_username = "test_deleted"
      deleted_email = "test@email_deleted.com"
      deleted_oauth_token = "1234"
      user = User.create(
        username: deleted_username,
        email: deleted_email,
        github_uid: deleted_uid,
        github_oauth_token: deleted_oauth_token,
      )
      user.delete!

      # Login with deleted user
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        :provider => "github",
        :uid => deleted_uid,
        :info => { :email => deleted_email, :nickname => deleted_username },
        :credentials => { :token => deleted_oauth_token }
      )
      post :create
      expect(flash[:error]).to eq "Your account has been deleted."
    end
  end

  describe "#logout" do
    it "should clear the session and redirect to homepage" do
      post :create
      expect(session[:u]).to_not be_nil
      post :logout
      expect(session[:u]).to be_nil
    end
  end
end
