class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :blog_id
      t.text :content

      t.timestamps
    end
  end
end
