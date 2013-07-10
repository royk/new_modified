class ChangeDrillDropsToString < ActiveRecord::Migration
  def change
	  change_column :drill_results, :drops, :string
  end
end
