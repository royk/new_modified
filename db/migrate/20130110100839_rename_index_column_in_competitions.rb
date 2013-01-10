class RenameIndexColumnInCompetitions < ActiveRecord::Migration
  def change
  	rename_column :competitions, :index, :order_index
  end
end
