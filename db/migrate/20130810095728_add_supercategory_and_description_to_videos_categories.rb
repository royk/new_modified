class AddSupercategoryAndDescriptionToVideosCategories < ActiveRecord::Migration
  def change
	  add_column :video_categories, :video_super_category_id, :integer
	  add_column :video_categories, :description, :string
	  add_index :video_categories, :video_super_category_id
  end
end
