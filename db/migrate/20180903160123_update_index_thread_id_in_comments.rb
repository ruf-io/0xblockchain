class UpdateIndexThreadIdInComments < ActiveRecord::Migration[5.2]
  def change
    remove_index :comments, :thread_id
    add_index :comments, :thread_id
  end
end
