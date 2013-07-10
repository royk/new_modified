class AddIndexToDrill < ActiveRecord::Migration
  def change
	  add_column :drill_results, :index, :integer
	  add_index :drill_results, [:training_session_id, :name]
  end
end
