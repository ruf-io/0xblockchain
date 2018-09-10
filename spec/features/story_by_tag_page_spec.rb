require 'rails_helper'

RSpec.feature "Tags page" do
  scenario "Story should be same tag" do
    # Create dummy tags
    tag_a = create :tag
    tag_b = create :tag

    # Create dummy stories
    stories_a = create_list :story, 5, :tag_names => [tag_a.tag]
    stories_b = create_list :story, 5, :tag_names => [tag_b.tag]

    # Visit tag_a page
    visit tag_path(tag_a)

    expect(page).to have_content tag_a.tag
    expect(page).to_not have_content tag_b.tag
    stories_a.each do |story|
      expect(page).to have_content story.title
    end

    visit tag_path(tag_b)
    expect(page).to_not have_content tag_a.tag
    expect(page).to have_content tag_b.tag
    stories_b.each do |story|
      expect(page).to have_content story.title
    end
  end

  scenario "random tag" do
    visit "/t/random_tag"

    expect(page).to have_current_path root_path
    expect(page).to have_content "random_tag tag is not available"
  end
end
