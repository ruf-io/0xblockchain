require 'rails_helper'

# This specification is to make sure that
# "Upvote story"" feature is work as expected
RSpec.feature "Upvote story" do
  describe "Guest user" do
    it "Should not be able to upvote the story", js: true do
      # Create dummy story
      stories = create_list :story, 3

      # Visit newest page and upvote one of the story
      visit newest_path
      find("a#upvote_story_" + stories.first.short_id).click

      # Make sure the
      accept_alert do
        alert_text = page.driver.browser.switch_to.alert.text
        expect(alert_text).to eq "Login or Join now to upvote stories"
      end
    end
  end

  describe "Authenticated user" do
    scenario "Upvote & unvote story", js: true do
      # It should be able to upvote other story
      user_a = create :user
      user_b = create :user
      story_b = create :story, :user => user_b

      # Then login as user_a
      stub_login_as user_a

      # upvote the story_b
      visit newest_path
      find("a#upvote_story_" + story_b.short_id).click

      # Point should be 2
      expect(page).to have_content "2 points"
      expect(story_b.points).to eq 2

      # Visit show page
      visit story_b.comments_path
      expect(page).to have_content "2 points"
      # Make sure the state are upvotted
      expect(page).to_not have_selector "a#upvote_story_" + story_b.short_id

      # Logout as user_a
      click_link "Logout"
      accept_alert

      # Then login as user_b
      stub_login_as user_b

      # Make sure the state are upvoted
      visit newest_path
      expect(page).to_not have_selector "a#upvote_story_" + story_b.short_id

      # let's unvote the story
      find("a#unvote_story_" + story_b.short_id).click

      # Point should be 1
      expect(page).to have_content "1 point"
      expect(story_b.points).to eq 1
    end
  end
end
