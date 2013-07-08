class AddDescriptionAndVideoToTrainingSession < ActiveRecord::Migration
  def change
	  add_column :training_sessions, :description, :text
	  add_column :training_sessions, :video_id, :integer
  end
end
