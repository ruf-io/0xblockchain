require 'rails_helper'

RSpec.feature "More stories feature" do
  scenario "Stories count less than equal 25" do
    # Create dummy story using factory bot
    create_list :story, 25

    # Visit homepage
    visit newest_path

    # Story should be available on the front-page
    expect(page).to_not have_content "More Stories"
  end

  scenario "Stories count larger than 25" do
    # Create dummy story using factory bot
    create_list :story, 30

    # Visit homepage
    visit newest_path
    # Link "More Stories" should be accessible
    expect(page).to have_content "More Stories"
    expect(page).to have_selector(:xpath,
                                  "/html/body/div/div[4]/ol/li[25]")

    # Click more stories
    click_link "More Stories"
    # Then test the next page
    expect(page).to_not have_content "More Stories"
    expect(page).to have_selector(:xpath,
                                  "/html/body/div/div[4]/ol/li[5]")
  end
end
