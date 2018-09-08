class CreateStoryVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :story_votes do |t|
      t.references :story, foreign_key: true
      t.references :user, foreign_key: true
      # Possible vote_score values:
      # +1 -> upvote
      # -1 -> downvote
      t.integer :vote_score, null: false
      t.datetime :upvoted_at
      t.datetime :downvoted_at

      t.index [:story_id, :user_id], unique: true

      t.timestamps
    end
  end
end
