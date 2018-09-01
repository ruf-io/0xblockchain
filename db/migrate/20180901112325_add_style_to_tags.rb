class AddStyleToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :background_color, :string, default: "#fef2c0"
    add_column :tags, :text_color, :string, default: "#000"
  end
end
