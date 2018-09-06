require 'rails_helper'

# This specification is to make sure that
# "Add comment" feature is work as expected
RSpec.feature "Add comment" do
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
      # Visit front page and click on the one of the story
      visit root_path
      find("a#comments_" + story_short_id).click

      # Make sure the form are disabled
      expect(page).to have_selector "#text_comment_" + story_short_id +"[disabled]"

      # Make sure the reply form are hidden
      comment_short_id = @stories.first.comments.first.short_id
      expect(page).to have_selector "form#reply_" + comment_short_id +".dn"
    end
  end

  describe "Authenticated user" do
    before do
      @stories = []
      create_list :story, 3 do |story|
        @stories.append(story)
        create :comment, :story => story
      end
      @user = create :user
      # Auth stub is defieed in support/authentication_helper.rb
      stub_login_as @user
    end

    scenario "Add comment", js: true do
      story_short_id = @stories.first.short_id
      # Visit front page and click on one of the story
      visit root_path
      find("a#comments_" + story_short_id).click

      # Make sure the form are enabled
      expect(page).to_not have_selector "#text_comment_" + story_short_id +"[disabled]"

      # Let's create a comment
      fill_in "comment[comment]",
              id: "text_comment_" + story_short_id,
              with: "My comment guys"
      click_button "Add comment"
      expect(page).to have_content @stories.first.title
      expect(page).to have_content "My comment guys"
      expect(page).to have_content "Comment added"
      expect(page).to have_content @user.username

      # Make sure we can't comment multiple times
      # in short interval
      fill_in "comment[comment]",
              id: "text_comment_" + story_short_id,
              with: "My another comment guys"
      click_button "Add comment"
      expect(page).to have_content @stories.first.title
      expect(page).to have_content "You have already posted a comment/reply here recently."

      # Test empty comment
      visit @stories.last.comments_path
      fill_in "comment[comment]",
              id: "text_comment_" + @stories.last.short_id,
              with: ""
      click_button "Add comment"
      expect(page).to have_content @stories.last.title
      expect(page).to have_content "cannot be blank"
    end

    scenario "Add reply", js: true do
      story_short_id = @stories.first.short_id
      # Create some comment first
      comment = create :comment, :story => @stories.first

      # Visit the story
      visit @stories.first.comments_path

      # Make sure the form are enabled
      expect(page).to_not have_selector "#text_comment_" + story_short_id +"[disabled]"

      # Let's create a reply
      # Click the reply link to reveal the form
      find("a#reply_form_toggler_" + comment.short_id).click
      # Then fill the form
      fill_in "comment[comment]",
              id: "text_comment_" + story_short_id + "_" + comment.short_id,
              with: "My reply guys"
      click_button "Add reply"
      expect(page).to have_content @stories.first.title
      expect(page).to have_content "My reply guys"
      expect(page).to have_content "Reply added"
      expect(page).to have_content comment.user.username

      # Visit the story to remove previous state
      visit @stories.first.comments_path
      # Make sure we can't reply multiple times
      # in short interval
      find("a#reply_form_toggler_" + comment.short_id).click
      # Then fill the form
      fill_in "comment[comment]",
              id: "text_comment_" + story_short_id + "_" + comment.short_id,
              with: "My another reply guys"
      click_button "Add reply"
      expect(page).to_not have_content "My another reply guys"
      expect(page).to_not have_content "Reply added"
      expect(page).to have_content "You have already posted a comment/reply here recently."

      # Comment and reply at short interval is OK
      # Because it is on different thread
      # First create another comment first
      comment_b = create :comment, :story => @stories.last
      # Then another story
      visit @stories.last.comments_path
      # Then create a comment
      fill_in "comment[comment]",
              id: "text_comment_" + @stories.last.short_id,
              with: "My comment guys"
      click_button "Add comment"

      # Then create a reply
      find("a#reply_form_toggler_" + comment_b.short_id).click
      # Then fill the form
      fill_in "comment[comment]",
              id: "text_comment_" + @stories.last.short_id + "_" + comment_b.short_id,
              with: "My another reply guys"
      click_button "Add reply"
      # This should be OK
      expect(page).to_not have_content "You have already posted a comment/reply here recently."
    end
  end
end
