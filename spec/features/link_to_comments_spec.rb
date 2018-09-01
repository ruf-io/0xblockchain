require 'rails_helper'

RSpec.feature "Link to comment spec" do
  describe "Front page" do
    scenario "story with no comment" do
      # Create dummy story using factory bot
      story = create :story

      # Visit homepage
      visit root_path

      # Story should be available on the front-page
      expect(page).to have_content story.title
      expect(page).to have_content story.user.username
      expect(page).to have_content "discuss"

      # Make sure the link is work
      click_link "discuss"
      expect(page).to have_content story.title
      expect(page).to have_content story.user.username
      expect(page).to have_current_path story.comments_path
    end

    scenario "story with 1 comment" do
      # Create dummy story using factory bot
      tag_names = []
      create_list :tag, 3 do |tag|
        tag_names.append(tag.tag)
      end
      story = create :story_with_comments,
                     tag_names: tag_names,
                     comments_count: 1
      # visit home page
      visit root_path
      # Story should be available on the front-page
      expect(page).to have_content story.title
      expect(page).to have_content story.user.username
      expect(page).to have_content "1 comment"

      # Make sure the link is work
      click_link "1 comment"
      expect(page).to have_content story.title
      expect(page).to have_content story.user.username
      expect(page).to have_current_path story.comments_path
    end

    scenario "story with 3 comments" do
      # Create dummy story using factory bot
      tag_names = []
      create_list :tag, 3 do |tag|
        tag_names.append(tag.tag)
      end
      story = create :story_with_comments,
                     tag_names: tag_names,
                     comments_count: 3
      # visit home page
      visit root_path

      # Story should be available on the front-page
      expect(page).to have_content story.title
      expect(page).to have_content story.user.username
      expect(page).to have_content "3 comments"

      # Make sure the link is work
      click_link "3 comments"
      expect(page).to have_content story.title
      expect(page).to have_content story.user.username
      expect(page).to have_content story.user.username
      expect(page).to have_current_path story.comments_path
    end
  end
end
