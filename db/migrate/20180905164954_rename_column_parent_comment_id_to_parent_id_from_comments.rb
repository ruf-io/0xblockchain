class RenameColumnParentCommentIdToParentIdFromComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :parent_comment_id, :parent_id
  end
end
