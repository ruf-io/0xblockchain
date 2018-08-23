class InstallFulltextExtensions < ActiveRecord::Migration[4.2]
    def up
      execute "CREATE EXTENSION IF NOT EXISTS btree_gin;"
      execute "CREATE EXTENSION IF NOT EXISTS btree_gist;"
    end

    def down
      execute "DROP EXTENSION IF EXISTS btree_gin;"
      execute "DROP EXTENSION IF EXISTS btree_gist;"
    end
  end