class AddStoreNameToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :store_name, :string
  end
end
