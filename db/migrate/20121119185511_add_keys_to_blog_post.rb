class AddKeysToBlogPost < ActiveRecord::Migration
  def change
  	add_index :blog_posts, [:blog_id, :created_at]
  end
end
