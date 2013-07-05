class FixAchievementsType < ActiveRecord::Migration
  def change
	  rename_column :achievements, :type, :achievement_type
  end
end
