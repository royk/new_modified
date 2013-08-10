class AddPermalinkToVideoCategories < ActiveRecord::Migration
  def change
    add_column :video_categories, :permalink, :string
  end
end
