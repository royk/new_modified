class AddPublicToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :public, :boolean
  end
end
