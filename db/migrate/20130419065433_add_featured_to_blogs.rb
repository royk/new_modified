class AddFeaturedToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :featured, :boolean, default: false
  end
end
