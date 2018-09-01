require 'rails_helper'

RSpec.feature "Points display feature" do
  scenario "Story score is equal to 0" do
    # Create dummy story using factory bot
    story = create :story
    # Downvote the story
    story.give_upvote_or_downvote_and_recalculate_hotness!(0, 1)

    # Visit homepage
    visit root_path
    expect(page).to have_content "0 point"
  end

  scenario "Story score is negative" do
    # Create dummy story using factory bot
    story = create :story
    # Downvote the story
    story.give_upvote_or_downvote_and_recalculate_hotness!(0, 2)

    # Should not displayed in the front page
    visit root_path
    expect(page).to_not have_content story.title
    # It should be available in the recent page
    visit recent_path
    expect(page).to have_content story.title
  end

  scenario "Story score is equal to 1" do
    # Create dummy story using factory bot
    create :story

    # Visit homepage
    visit root_path
    expect(page).to have_content "1 point"
  end

  scenario "Stories count larger than 1" do
    # Create dummy story using factory bot
    story = create :story
    # Upvote existing stories 3 times
    story.give_upvote_or_downvote_and_recalculate_hotness!(3, 0)

    # Visit homepage
    visit root_path
    expect(page).to have_content "4 points"
  end
end
