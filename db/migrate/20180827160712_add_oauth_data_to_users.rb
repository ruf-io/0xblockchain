class AddOauthDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :github_uid, :string
    add_column :users, :github_oauth_token, :string

    add_index :users, :github_uid, unique: true
  end
end
