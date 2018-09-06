require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "Guest user" do
    scenario "Post new comment" do
      # Create dummy story
      story = create :story

      post :create, :params => {
        :comment => {
          :story_id => story.short_id,
          :comment => "Hi there! Guest user here",
        },
      }
      # Make sure they uanble to add a comment
      expect(response).to redirect_to root_path
      guest_comment = Comment.find_by(comment: "Hi there! Guest user here")
      expect(guest_comment).to be_nil
    end
  end
end
