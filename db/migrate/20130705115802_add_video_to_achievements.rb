class AddVideoToAchievements < ActiveRecord::Migration
  def change
	  add_column :achievements, :video_id, :integer
  end
end
