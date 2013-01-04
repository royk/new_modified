class AddHiddenAndUserIdToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :hidden, :boolean, default: false
    add_column :feeds, :user_id, :integer
  end
end
