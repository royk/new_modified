class AddFeedIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :feed_id, :integer
  end
end
