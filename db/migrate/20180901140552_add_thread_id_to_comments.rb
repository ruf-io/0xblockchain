class AddThreadIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :thread_id, :integer, unsigned: true

    add_index :comments, :thread_id, unique: true
  end
end
