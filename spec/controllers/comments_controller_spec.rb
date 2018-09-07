require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "Guest user" do
    it "should not be able to post new comment" do
      # Create dummy story
      story = create :story

      post :create, :params => {
        :comment => {
          :story_id => story.short_id,
          :comment => "Hi there! Guest user here",
        },
      }

      # Make sure they are unable to add a comment
      expect(response).to redirect_to root_path
      guest_comment = Comment.find_by(comment: "Hi there! Guest user here")
      expect(guest_comment).to be_nil
    end

    it "should not be able to edit existing comment" do
      comment = create :comment

      # Edit comment
      post :update, :params => {
        :id => comment.short_id,
        :comment => {
          :comment => "Edit comment",
        },
      }

      # Make sure they are unable to edit a comment
      expect(response).to redirect_to root_path
      guest_comment = Comment.find_by(comment: "Edit comment")
      expect(guest_comment).to be_nil
    end
  end
end
