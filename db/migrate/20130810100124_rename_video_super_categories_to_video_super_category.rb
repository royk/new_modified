class RenameVideoSuperCategoriesToVideoSuperCategory < ActiveRecord::Migration
	def up
		rename_table :video_super_categories, :video_super_categories
	end

	def down
		rename_table :video_super_categories, :video_super_categories
	end
end
