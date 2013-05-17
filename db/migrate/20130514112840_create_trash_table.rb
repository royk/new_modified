class CreateTrashTable < ActiveRecord::Migration
	ActsAsTrashable::TrashRecord.create_table
end
