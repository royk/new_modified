class RenameSessionsToTrainingSessions < ActiveRecord::Migration
  def change
	  rename_table :sessions, :training_sessions
  end

end
