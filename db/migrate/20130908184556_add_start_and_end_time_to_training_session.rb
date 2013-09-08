class AddStartAndEndTimeToTrainingSession < ActiveRecord::Migration
  def change
	  add_column :training_sessions, :startTime, :datetime
	  add_column :training_sessions, :endTime, :datetime
  end
end
