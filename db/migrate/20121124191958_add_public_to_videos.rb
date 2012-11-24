class AddPublicToVideos < ActiveRecord::Migration
  def change
	add_column :videos, :public, :boolean
  end
end
