class CreateTrainingDrillResults < ActiveRecord::Migration
  def change
    create_table :training_drill_results do |t|
      t.integer :training_session_id
      t.integer :training_drill_id
      t.integer :attempts_count

      t.timestamps
    end
  end
end
