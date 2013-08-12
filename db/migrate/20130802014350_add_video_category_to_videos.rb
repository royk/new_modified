class AddVideoCategoryToVideos < ActiveRecord::Migration
  def change
	  add_column :videos, :video_category_id, :integer
	  add_index :videos, :video_category_id
  end
end