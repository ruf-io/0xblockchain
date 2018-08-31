require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  describe "Guest user" do
    scenario "Access submit story page" do
      # Perform request
      get :new
      # Make sure it is redirected to the home page
      # and contains error message
      expect(response).to redirect_to root_path
      expect(response).to have_http_status :found # 302
    end

    scenario "Submit story" do
      # Perform request
      # Create dummy tag
      tag1 = create :tag
      tag2 = create :tag
      post :create, :params => {
        :story => {
          :title => "test",
          :url => "https://0xblockchain.network",
          :tags_a => [tag1.tag, tag2.tag],
        },
      }
      # Make sure it is redirected to the home page
      # and contains error message
      expect(response).to redirect_to root_path
      expect(response).to have_http_status :found # 302
    end
  end

  describe "Authenticated user" do
    before do
      # Create random user and stub login
      user = create :user
      user.update_column(:session_token, 'asdf')
      allow_any_instance_of(ApplicationController)
        .to receive(:session)
        .and_return(u: 'asdf')
    end

    scenario "Access new story page" do
      # Perform request
      get :new
      # Make sure it is redirected to the home page
      # and contains error message
      expect(response).to have_http_status :success # 200
    end

    scenario "Submit valid story" do
      # Create dummy tag
      tag1 = create :tag
      tag2 = create :tag

      # URL only without text
      post :create, :params => {
        :story => {
          :title => "test",
          :url => "https://0xblockchain.network",
          :tags_a => [tag1.tag, tag2.tag],
        },
      }
      # Make sure it is success
      expect(response).to have_http_status :found # 302
      story = Story.find_by(title: "test")
      expect(story).to be_valid
      expect(response).to redirect_to story.comments_path

      # Text only without URL
      post :create, :params => {
        :story => {
          :title => "test lagi bosku",
          :description => "Test my description",
          :tags_a => [tag1.tag],
        },
      }
      # Make sure it is success
      expect(response).to have_http_status :found # 302
      story = Story.find_by(title: "test lagi bosku")
      expect(story).to be_valid
      expect(response).to redirect_to story.comments_path
    end

    scenario "Submit invalid story" do
    end
  end
end
