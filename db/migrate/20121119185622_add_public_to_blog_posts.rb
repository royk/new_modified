class AddPublicToBlogPosts < ActiveRecord::Migration
  def change
  	add_column :blog_posts, :public, :boolean
  end
end
