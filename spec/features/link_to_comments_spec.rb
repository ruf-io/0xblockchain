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
    end
  end
end
