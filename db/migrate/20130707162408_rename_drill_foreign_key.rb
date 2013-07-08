class RenameDrillForeignKey < ActiveRecord::Migration
  def change
	  rename_column :drill_results, :session_id, :training_session_id
  end
end
