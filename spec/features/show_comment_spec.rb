require 'rails_helper'

# Show comment spec
RSpec.feature "Show comment" do
  it "Can be accessed by public" do
    comment = create :comment
    visit comment_path(comment)
    expect(page).to have_content comment.comment
  end
end
