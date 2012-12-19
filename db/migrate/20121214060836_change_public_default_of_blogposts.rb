class ChangePublicDefaultOfBlogposts < ActiveRecord::Migration
  def change
  	change_column :blog_posts, :public, :boolean, default: false
  end
end
