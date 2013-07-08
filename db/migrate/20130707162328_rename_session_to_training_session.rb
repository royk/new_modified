class RenameSessionToTrainingSession < ActiveRecord::Migration
	def up
		rename_table :sessions, :training_sessions
	end

	def down
		rename_table :training_sessions, :sessions
	end
end
