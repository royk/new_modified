class AddDropsArrayToTrainingDrillResult < ActiveRecord::Migration
  def change
    add_column :training_drill_results, :drops, :string
  end
end
