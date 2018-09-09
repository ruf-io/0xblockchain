require 'rails_helper'

RSpec.feature "Points display feature" do
  scenario "Story score is equal to 0" do
    # Create dummy story using factory bot
    story = create :story
    # Downvote the story
    user_a = create :user
    user_a.downvote_story story

    # Visit newest path
    visit newest_path
    expect(page).to have_content "0 point"
  end

  scenario "Story score is negative" do
    # Create dummy story using factory bot
    story = create :story
    # Downvote the story
    user_a = create :user
    user_a.downvote_story story
    user_b = create :user
    user_b.downvote_story story

    # Should not displayed in the front page
    visit root_path
    expect(page).to_not have_content story.title
    # It should be available in the newest page
    visit newest_path
    expect(page).to have_content story.title
  end

  scenario "Story score is equal to 1" do
    # Create dummy story using factory bot
    create :story

    # Visit homepage
    visit newest_path
    expect(page).to have_content "1 point"
  end

  scenario "Stories count larger than 1" do
    # Create dummy story using factory bot
    story = create :story
    # Upvote existing stories 3 times
    user_a = create :user
    user_a.upvote_story story
    user_b = create :user
    user_b.upvote_story story
    user_c = create :user
    user_c.upvote_story story

    # Visit homepage
    visit newest_path
    expect(page).to have_content "4 points"
  end
end
