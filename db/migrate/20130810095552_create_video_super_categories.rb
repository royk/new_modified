class CreateVideoSuperCategories < ActiveRecord::Migration
  def change
	  create_table :video_super_categories do |t|
		  t.string :name
		  t.string :permalink
		  t.timestamps
	  end
  end
end
