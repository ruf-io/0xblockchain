require 'rails_helper'

# This specification test the "edit" link
# Make sure it is work as expected
RSpec.feature "Edit story" do
  # Test guest user
  describe "Guest user" do
    before do
      @stories = []
      create_list :story, 3 do |story|
        @stories.append(story)
      end
    end
    it "Should not see the edit button" do
      # Visit front page and make sure there
      # is no edit button
      visit root_path
      expect(page).to_not have_content "edit"

      # Visit recent path and make sure there
      # is no edit button
      visit recent_path
      expect(page).to_not have_content "edit"

      # Click one of the story and make sure there
      # is no edit button
      visit @stories.first.comments_path
      expect(page).to_not have_content "edit"
    end
  end

  describe "Authenticated user (non-moderator)" do
    before do
      @user = create :user
      # stub_login_as is defined in support/authentication_helper
      stub_login_as @user
    end

    it "Cannot see link to edit other people story" do
      # Create dummy story
      stories = []
      create_list :story, 6 do |story|
        stories.append(story)
      end
      # Visit front page and make sure there
      # is no edit button
      visit root_path
      expect(page).to_not have_content "edit"

      # Visit recent path and make sure there
      # is no edit button
      visit recent_path
      expect(page).to_not have_content "edit"

      # Click one of the story and make sure there
      # is no edit button
      visit stories.first.comments_path
      expect(page).to_not have_content "edit"
    end

    scenario "Story no longer than 6 hours" do
      # Create dummy story
      story = create :story, :user => @user
      # Visit front page and make sure there
      # is edit button
      visit root_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)

      # Visit recent path and make sure there
      # is edit button
      visit recent_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)

      # Click one of the story and make sure there
      # is edit button
      visit story.comments_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)
    end

    scenario "Story longer than 6 hours" do
      # Create dummy story
      seven_hours = 7 * 60 * 60
      created_at = Time.now.utc - seven_hours
      story = create :story, :user => @user, :created_at => created_at

      # Visit front page and make sure there
      # is edit button
      visit root_path
      expect(page).to_not have_content "edit"

      # Visit recent path and make sure there
      # is edit button
      visit recent_path
      expect(page).to_not have_content "edit"

      # Click one of the story and make sure there
      # is edit button
      visit story.comments_path
      expect(page).to_not have_content "edit"
    end

    it "Can edit and see the result" do
      story = create :story, :user => @user

      # Visit recent path and make sure there
      # is edit button
      visit recent_path
      click_link "edit"
      # save_and_open_page

      expect(page).to have_current_path edit_story_path(story)
      expect(find("#story_title").value).to eq story.title
      if story.description.present?
        expect(find("#story_description").text).to eq story.description
      end
      if story.url.present?
        expect(find("#story_url").value).to eq story.url
      end
      expect(page).to have_selector(:link_or_button, "Update Story")
      expect(page).to have_selector(:link_or_button, "Cancel Edit")

      # test the cancel button
      click_link "Cancel Edit"
      expect(page).to have_current_path recent_path

      # Visit the edit pat directly
      visit edit_story_path(story)
      # Update the form
      fill_in "story[title]", with: "Test update"
      fill_in "story[description]", with: "Test description"
      click_button "Update Story"

      expect(page).to have_content "Test update"
      expect(page).to have_content "Test description"
      expect(page).to have_content story.tag_names.first
    end
  end

  describe "Authenticated user (moderator)" do
    before do
      @user = create :user, is_moderator: true
      # stub_login_as is defined in support/authentication_helper
      stub_login_as @user
    end

    it "Can see link to edit other people story" do
      # Create dummy story
      stories = []
      create_list :story, 6 do |story|
        stories.append(story)
      end
      # Visit front page and make sure there
      # is edit button
      visit root_path
      expect(page).to have_content "edit"

      # Visit recent path and make sure there
      # is edit button
      visit recent_path
      expect(page).to have_content "edit"

      # Click one of the story and make sure there
      # is edit button
      visit stories.first.comments_path
      expect(page).to have_content "edit"
    end

    scenario "Story no longer than 6 hours" do
      # Create dummy story
      story = create :story, :user => @user
      # Visit front page and make sure there
      # is edit button
      visit root_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)

      # Visit recent path and make sure there
      # is edit button
      visit recent_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)

      # Click one of the story and make sure there
      # is edit button
      visit story.comments_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)
    end

    scenario "Story longer than 6 hours" do
      # Create dummy story
      seven_hours = 7 * 60 * 60
      created_at = Time.now.utc - seven_hours
      story = create :story, :user => @user, :created_at => created_at

      # Visit front page and make sure there
      # is edit button
      visit root_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)

      # Visit recent path and make sure there
      # is edit button
      visit recent_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)

      # Click one of the story and make sure there
      # is edit button
      visit story.comments_path
      expect(page).to have_content "edit"
      click_link "edit"
      expect(page).to have_current_path edit_story_path(story)
    end
  end
end
