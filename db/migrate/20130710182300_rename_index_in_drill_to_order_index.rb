class RenameIndexInDrillToOrderIndex < ActiveRecord::Migration
  def change
	  rename_column :drill_results, :index, :order_index
  end
end
