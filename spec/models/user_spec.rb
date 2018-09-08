require "rails_helper"

describe User do
  it "has a valid username" do
    expect { create(:user, :username => nil) }.to raise_error
    expect { create(:user, :username => "") }.to raise_error
    expect { create(:user, :username => "*") }.to raise_error

    create(:user, :username => "newbie")
    expect { create(:user, :username => "newbie") }.to raise_error
  end

  it "has a valid email address" do
    create(:user, :email => "user@example.com")

    # duplicate
    expect { create(:user, :email => "user@example.com") }.to raise_error

    # bad address
    expect { create(:user, :email => "user@") }.to raise_error
  end

  it "gets an error message after registering banned name" do
    expect { create(:user, :username => "admin") }
           .to raise_error("Validation failed: Username is not permitted")
  end

  it "shows a user is banned or not" do
    u = create(:user, :banned)
    user = create(:user)
    expect(u.is_banned?).to be true
    expect(user.is_banned?).to be false
  end

  it "shows a user is active or not" do
    u = create(:user, :banned)
    user = create(:user)
    expect(u.is_active?).to be false
    expect(user.is_active?).to be true
  end

  it "shows a user is recent or not" do
    user = create(:user, :created_at => Time.now.utc)
    u = create(:user, :created_at => Time.now.utc - 8.days)
    expect(user.is_new?).to be true
    expect(u.is_new?).to be false
  end

  it "unbans a user" do
    u = create(:user, :banned)
    expect(u.unban_by_user!(User.first)).to be true
  end

  it "tells if a user is a heavy self promoter" do
    u = create(:user)

    expect(u.is_heavy_self_promoter?).to be false

    create(:story, :title => "ti1", :url => "https://a.com/1", :user_id => u.id,
      :user_is_author => true)
    # require at least 2 stories to be considered heavy self promoter
    expect(u.is_heavy_self_promoter?).to be false

    create(:story, :title => "ti2", :url => "https://a.com/2", :user_id => u.id,
      :user_is_author => true)
    # 100% of 2 stories
    expect(u.is_heavy_self_promoter?).to be true

    create(:story, :title => "ti3", :url => "https://a.com/3", :user_id => u.id,
      :user_is_author => false)
    # 66.7% of 3 stories
    expect(u.is_heavy_self_promoter?).to be true

    create(:story, :title => "ti4", :url => "https://a.com/4", :user_id => u.id,
      :user_is_author => false)
    # 50% of 4 stories
    expect(u.is_heavy_self_promoter?).to be false
  end

  describe "karma points" do
    it "should work as expected" do
      # Create dummy user
      user_a = create :user
      # Create dummy stories
      create_list :story, 3, :user => user_a
      expect(user_a.karma_points_story).to be 0

      # Create dummy voters
      user_b = create :user
      user_b.upvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 1

      # Create dummy voters
      user_c = create :user
      user_c.upvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 2

      # Create dummy voters
      user_d = create :user
      user_d.downvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 1

      # Create dummy voters
      user_e = create :user
      user_e.downvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 0

      # Undo all votes
      user_e.unvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 1
      user_d.unvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 2
      user_c.unvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 1
      user_b.unvote_story user_a.stories.first
      expect(user_a.karma_points_story).to be 0
    end
  end
end
