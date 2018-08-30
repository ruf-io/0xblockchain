require 'rails_helper'

RSpec.feature "Create and edit tags" do
  describe "Guest user" do
    it "should not be able to see 'create new tag' and 'edit' link" do
      # Go to tags page
      visit tags_path

      # Test the response
      expect(page).to_not have_content "Edit"
      expect(page).to_not have_content "Create New Tag"
    end
  end

  describe "Non-admin user" do
    before do
      # Stub available at support/authentication_helper.rb
      stub_login_as_nonadmin_user
    end

    it "should not be able to see 'create new tag' and 'edit' link" do
      # Go to tags page
      visit tags_path

      # Test the response
      expect(page).to_not have_content "Edit"
      expect(page).to_not have_content "Create New Tag"
    end
  end

  describe "Admin user" do
    before do
      # Stub available at support/authentication_helper.rb
      stub_login_as_admin_user
    end

    it "should be able to see 'create new tag' and 'edit' link" do
      # Go to tags page
      visit tags_path

      # Test the response
      expect(page).to have_content "Edit"
      expect(page).to have_content "Create new tag"
    end

    scenario "admin user create tag with blank name" do
      # Go to tags page
      visit tags_path

      # Click the new tag button
      click_link "Create new tag"

      # Don't fill the form, just submit the content
      click_button "Create tag"

      # It should display an error
      expect(page).to have_content "New tag not created: Tag can't be blank"
    end

    scenario "admin user create 'test' tag" do
      # Go to tags page
      visit tags_path

      # Click the new tag button
      click_link "Create new tag"

      # fill the form and submit the content
      fill_in "tag[tag]", with: "test"
      fill_in "tag[description]", with: "Some tag description"
      click_button "Create tag"

      # It should redirected to tag path and display success message
      expect(page).to have_current_path tags_path
      expect(page).to have_content "Tag \"test\" has been created"
      expect(page).to have_content "Some tag description"
    end

    scenario "admin user update 'test2' tag" do
      # Create the tag first with empty description
      tag = Tag.create(tag: "test2")

      # Go to tags page
      visit tags_path
      expect(page).to_not have_content "Some tag update description"

      # Click the edit link
      find("a.tag-%s" % tag.id).click

      # fill the form and submit the content
      fill_in "tag[description]", with: "Some tag update description"
      click_button "Update tag"

      # It should redirected to tag path and display success message
      expect(page).to have_current_path tags_path
      expect(page).to have_content "Tag \"test2\" has been updated"
      expect(page).to have_content "Some tag update description"
    end
  end
end
