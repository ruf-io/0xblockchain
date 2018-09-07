require 'rails_helper'

# This is a "edit" link on the comment specification
# This is to make sure that it's work as expected
RSpec.feature "Edit comment" do
  # Test guest user
  describe "Guest user" do
    before do
      @stories = []
      create_list :story, 3 do |story|
        @stories.append(story)
      end

      @comment = create :comment
    end

    it "Should not see the edit button" do
      @stories.each do |story|
        visit story.comments_path
        expect(page).to_not have_content "edit"
      end
    end

    it "Can't access the edit_comment_path" do
      visit edit_comment_path(@comment)
      expect(page).to have_current_path root_path
      expect(page).to have_content "Access denied. You must login to access that page."
    end
  end

  describe "Authenticated user (non-moderator)" do
    it "should be able to edit the comment if no longer than 6 hours" do
      # Create random user, story and coment
      user = create :user
      story = create :story
      comment = create :comment, :user => user, :story => story

      # Login as user
      stub_login_as user

      # Visit the story page
      visit story.comments_path

      # Edit link should be available
      find("a#edit_c_" + comment.short_id).click
      expect(page).to have_current_path edit_comment_path(comment)
      fill_in "comment[comment]", with: "My update guys"
      click_button "Update comment"
      expect(page).to have_content story.title
      expect(page).to have_content "My update guys"
      expect(page).to have_current_path story.comments_path
    end

    it "should not be able to edit the comment if longer than 6 hours" do
      # Create random user, story and coment
      user = create :user
      story = create :story

      # Login as user
      stub_login_as user

      # Create dummy comment
      seven_hours = 7 * 60 * 60
      created_at = Time.now.utc - seven_hours
      comment = create :comment,
                       :user => user,
                       :story => story,
                       :created_at => created_at

      # Visit the story page
      visit story.comments_path

      # Edit link should be unavailable
      expect(page).to_not have_selector "a#edit_c_" + comment.short_id

      # User can't access the edit page directly
      visit edit_comment_path(comment)
      expect(page).to have_current_path root_path
      expect(page).to have_content "You can't edit the comment."
    end

    it "should not be able to edit the comment of other user" do
      # Create random user, story and coment
      user_a = create :user
      user_b = create :user
      story = create :story

      # Create dummy comment
      seven_hours = 7 * 60 * 60
      created_at = Time.now.utc - seven_hours
      comment = create :comment,
                       :user => user_a,
                       :story => story,
                       :created_at => created_at

      # Login as user B
      stub_login_as user_b

      # Visit the story page
      visit story.comments_path

      # Edit link should be unavailable
      expect(page).to_not have_selector "a#edit_c_" + comment.short_id

      # User can't access the edit page directly
      visit edit_comment_path(comment)
      expect(page).to have_current_path root_path
      expect(page).to have_content "You can't edit the comment."
    end
  end

  describe "Authenticated user (moderator)" do
    it "should be able to edit the comment if no longer than 6 hours" do
      # Create random user, story and coment
      user = create :user, is_moderator: true
      story = create :story
      comment = create :comment, :user => user, :story => story

      # Login as user
      stub_login_as user

      # Visit the story page
      visit story.comments_path

      # Edit link should be available
      find("a#edit_c_" + comment.short_id).click
      expect(page).to have_current_path edit_comment_path(comment)
      fill_in "comment[comment]", with: "My update guys"
      click_button "Update comment"
      expect(page).to have_content story.title
      expect(page).to have_content "My update guys"
      expect(page).to have_current_path story.comments_path
    end

    it "should not be able to edit the comment if longer than 6 hours" do
      # Create random user, story and coment
      user = create :user, is_moderator: true
      story = create :story

      # Login as user
      stub_login_as user

      # Create dummy comment
      seven_hours = 7 * 60 * 60
      created_at = Time.now.utc - seven_hours
      comment = create :comment,
                       :user => user,
                       :story => story,
                       :created_at => created_at

      # Visit the story page
      visit story.comments_path

      # Edit link should be unavailable
      expect(page).to_not have_selector "a#edit_c_" + comment.short_id

      # User can't access the edit page directly
      visit edit_comment_path(comment)
      expect(page).to have_current_path root_path
      expect(page).to have_content "You can't edit the comment."
    end

    it "should not be able to edit the comment of other user" do
      # Create random user, story and coment
      user_a = create :user
      user_b = create :user, is_moderator: true
      story = create :story

      # Create dummy comment
      seven_hours = 7 * 60 * 60
      created_at = Time.now.utc - seven_hours
      comment = create :comment,
                       :user => user_a,
                       :story => story,
                       :created_at => created_at

      # Login as user B
      stub_login_as user_b

      # Visit the story page
      visit story.comments_path

      # Edit link should be unavailable
      expect(page).to_not have_selector "a#edit_c_" + comment.short_id

      # User can't access the edit page directly
      visit edit_comment_path(comment)
      expect(page).to have_current_path root_path
      expect(page).to have_content "You can't edit the comment."
    end
  end
end
