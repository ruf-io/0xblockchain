class CreateStorySaves < ActiveRecord::Migration[5.2]
  def change
    create_table :story_saves do |t|
      t.references :story, foreign_key: true
      t.references :user, foreign_key: true

      t.index [:story_id, :user_id], unique: true

      t.timestamps
    end
  end
end
