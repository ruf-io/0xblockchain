class AddShortIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :short_id, :string, limit: 10, default: "", null: false

    add_index :comments, :short_id, unique: true
  end
end
