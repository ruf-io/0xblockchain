require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe "Guest user" do
    scenario "Access index" do
      # Perform request
      get :index
      expect(response).to have_http_status :success # 200
    end
    scenario "Access new tag page" do
      # Perform request
      get :new
      # Make sure it is redirected to the home page
      # and contains error message
      expect(response).to redirect_to root_path
      expect(response).to have_http_status :found # 302
    end
  end

  describe "Existing user" do
    before do
      # Create random user and stub login
      user = create :user
      user.update_column(:session_token, 'asdf')
      allow_any_instance_of(ApplicationController)
        .to receive(:session)
        .and_return(u: 'asdf')
    end

    scenario "Access index" do
      # Perform request
      get :index
      expect(response).to have_http_status :success # 200
    end

    scenario "Access new tag page" do
      # Perform request
      get :new
      # Make sure it is redirected to the home page
      # and contains error message
      expect(flash[:error]).to eq "You are not authorized to access that resource."
    end
  end

  describe "Existing user (admin)" do
    before do
      # Create random admin user and stub login
      user = create :user, :is_admin => true
      user.update_column(:session_token, 'asdf')
      allow_any_instance_of(ApplicationController)
        .to receive(:session)
        .and_return(u: 'asdf')
    end

    scenario "Access index" do
      # Perform request
      get :index
      expect(response).to have_http_status :success # 200
    end

    scenario "Access new tag page" do
      # Perform request
      get :new
      # Make sure it is redirected to the home page
      # and contains error message
      expect(response).to have_http_status :success
    end

    scenario "Create new valid tag" do
      # Perform request
      post :create, :params => { :tag => { :tag => "test" } }
      # expect success
      expect(response).to redirect_to tags_path
      expect(flash[:success]).to eq "Tag \"test\" has been created"
    end

    scenario "Create new invalid tag" do
      # Perform request
      post :create, :params => { :tag => { :tag => "tofuckinglongtagnamewhatthefuckisgoingon" } }

      # expect error
      expect(response).to redirect_to new_tag_path
      expect(flash[:error]).to eq "New tag not created: Tag is too long (maximum is 25 characters)"
    end
  end
end
