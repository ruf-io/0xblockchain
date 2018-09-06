require 'rails_helper'

# This test is to make sure that the user can access
# the detail page of the story
RSpec.feature "Show story" do
  scenario "Text only story" do
    # First, create the dummy story
    story = create :story, description: "Test text", url: nil

    # Visit root path, make sure it is accesible
    visit root_path
    # then click the title, it should be directed to
    # comments path
    click_link story.title
    expect(page).to have_current_path story.comments_path

    # Visit root path again
    visit root_path
    # Make sure the description link is available
    # and it is click-able
    find("#description_" + story.short_id).click
    expect(page).to have_current_path story.comments_path

    # Visit root path again
    visit root_path
    # Make sure the 'discuss' link is available
    # and it is click-able
    find("#comments_" + story.short_id).click
    expect(page).to have_current_path story.comments_path
  end

  scenario "URL only story" do
    # First, create the dummy story
    story = create :story, description: nil, url: "https://test.com"

    # Visit root path, make sure it is accesible
    visit root_path
    # Make sure the title is linked to story url
    expect(find("a#link-"+story.short_id)[:href]).to eq "https://test.com"
    # Make sure the description link is not exists
    expect(page).to_not have_selector "description-" + story.short_id

    # Visit root path again
    visit root_path
    # Make sure the 'discuss' link is available
    # and it is click-able
    find("#comments_" + story.short_id).click
    expect(page).to have_current_path story.comments_path
  end

  scenario "Story with text and URL" do
    # First, create the dummy story
    story = create :story,
                   :description => "hello",
                   :url => "https://test.com"

    # Visit root path, make sure it is accesible
    visit root_path
    # Make sure the description link is available
    # and it is click-able
    find("#description_" + story.short_id).click
    expect(page).to have_current_path story.comments_path

    # Visit root path again
    visit root_path
    # Make sure the 'discuss' link is available
    # and it is click-able
    find("#comments_" + story.short_id).click
    expect(page).to have_current_path story.comments_path
  end

  scenario "Story not exists" do
    # Visit story that not exists
    visit "/s/test_story_id/test_title"
    expect(page).to have_current_path root_path
  end
end
