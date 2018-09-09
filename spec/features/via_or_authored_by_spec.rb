require 'rails_helper'

RSpec.feature "Via or Authored by" do
  scenario "via" do
    # Create dummy story using factory bot
    story = create :story, user_is_author: false

    # Visit newest page
    visit newest_path
    expect(page).to have_content "via " + story.user.username

    # Make sure link to the user profile is work
    click_link story.user.username
    expect(page).to have_current_path "/u/" + story.user.username
  end

  scenario "authored by" do
    # Create dummy story using factory bot
    story = create :story, user_is_author: true

    # Visit newest page
    visit newest_path
    expect(page).to have_content "authored by " + story.user.username

    # Make sure link to the user profile is work
    click_link story.user.username
    expect(page).to have_current_path "/u/" + story.user.username
  end
end
