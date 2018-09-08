class StoryVote < ApplicationRecord
  belongs_to :story
  belongs_to :user

  enum vote_score: { upvoted: 1, downvoted: -1 }
end
