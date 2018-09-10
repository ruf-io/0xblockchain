require 'rails_helper'

RSpec.feature "Newest page" do
  scenario "Story should be available in newest page" do
    stories = create_list :story, 5

    # Visit newest page
    visit newest_path
    stories.each do |story|
      expect(page).to have_content story.title
    end
  end
end
