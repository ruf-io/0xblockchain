require 'rails_helper'

# This specification is to make sure that
# reply form in the show stories is expandable
RSpec.feature "Reply comment" do
  describe "Guest user" do
    before do
      @stories = []
      create_list :story, 3 do |story|
        @stories.append(story)
        create :comment, :story => story
      end
    end

    it "Should not be able to access the form" do
      story_short_id = @stories.first.short_id
      # Visit front page and click on of the story
      visit root_path
      find("a#comments_" + story_short_id).click

      # Make sure the form are disabled
      expect(page).to have_selector "#text_comment_" + story_short_id +"[disabled]"

      # Make sure the reply form are hidden
      comment_short_id = @stories.first.comments.first.short_id
      expect(page).to have_selector "#reply_" + comment_short_id +".dn"
    end
  end

  describe "Authenticated user (non-moderator)" do
  end
end
