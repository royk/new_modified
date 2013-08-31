class AddDropsToTrainingDrillResult < ActiveRecord::Migration
  def change
    add_column :training_drill_results, :drops_count, :integer
  end
end
