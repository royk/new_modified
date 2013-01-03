class AddFeedIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :feed_id, :integer
  end
end
