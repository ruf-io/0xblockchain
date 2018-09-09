require 'rails_helper'

# This specification is to make sure that
# Front page feature is work as expected
RSpec.feature "Front page" do
  it "Should short story by hotness score" do
    # Create dummy story
    story = create :story

    # It should be available in newest page but not
    # in the front-page
    visit newest_path
    expect(page).to have_content story.title
    visit root_path
    expect(page).to_not have_content story.title

    # Recalculate the story
    story.hotness = story.hotness_score
    story.save!

    # It should be available in the front-page
    visit root_path
    expect(page).to have_content story.title
  end
end
