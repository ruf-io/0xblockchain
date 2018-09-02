require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  describe "Guest user" do
    scenario "Access submit story page" do
      get :new
      expect(response).to redirect_to root_path
    end

    scenario "Submit story" do
      # Create dummy tag first
      tag1 = create :tag
      tag2 = create :tag
      # Try to submit story
      post :create, :params => {
        :story => {
          :title => "i'm a guest user",
          :url => "https://0xblockchain.network",
          :tag_names => [tag1.tag, tag2.tag],
        },
      }
      # Make sure it is not inserted to the database
      story = Story.find_by(title: "i'm a guest user")
      expect(story).to be_nil
    end

    scenario "Edit story" do
      # Create dummy tag first
      tag1 = create :tag
      tag2 = create :tag
      story = create :story
      # Try to edit story
      post :update, :params => {
        :id => story.short_id,
        :story => {
          :title => "i'm a guest user",
          :url => "https://0xblockchain.network",
          :tag_names => [tag1.tag, tag2.tag],
        },
      }
      # Make sure it is not inserted to the database
      story = Story.find_by(title: "i'm a guest user")
      expect(story).to be_nil
    end
  end

  describe "Authenticated user" do
    before do
      # Create random user and stub login
      @user = create :user, username: "jancok"
      @user.update_column(:session_token, 'asdf')
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
          :tag_names => [tag1.tag, tag2.tag],
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
          :tag_names => [tag1.tag],
        },
      }
      # Make sure it is success
      expect(response).to have_http_status :found # 302
      story = Story.find_by(title: "test lagi bosku")
      expect(story).to be_valid
      expect(response).to redirect_to story.comments_path
    end

    scenario "User edit their own story" do
      # Create dummy tag
      story = create :story, :user => @user

      # URL only without text
      post :update, :params => {
        :id => story.short_id,
        :story => {
          :title => "test",
          :url => "https://0xblockchain.network",
          :description => "oke",
        },
      }
      # Make sure it is success
      updated_story = Story.find_by(id: story.id)
      expect(updated_story).to be_valid
      expect(updated_story.title).to eq "test"
      expect(updated_story.url).to eq "https://0xblockchain.network"
      expect(updated_story.description).to eq "oke"

      # Text only without URL
      post :update, :params => {
        :id => story.short_id,
        :story => {
          :title => "test lagi bosku",
          :description => "Test my description",
        },
      }
      # Make sure it is success
      expect(response).to have_http_status :found # 302
      story = Story.find_by(id: story.id)
      expect(story).to be_valid
      expect(story.title).to eq "test lagi bosku"
    end

    scenario "Edit other story" do
      # Create dummy tag
      tag1 = create :tag
      tag2 = create :tag
      # Create other user's story
      story = create :story

      # Try to update the other story
      post :update, :params => {
        :id => story.short_id,
        :story => {
          :title => "test",
          :url => "https://0xblockchain.network",
          :tag_names => [tag1.tag, tag2.tag],
        },
      }
      # Make sure it is not inserted to the database
      story = Story.find_by(id: story.id)
      expect(story).to be_valid
      expect(story.title).to_not eq "test"
    end

    scenario "Submit invalid story" do
    end
  end
end
