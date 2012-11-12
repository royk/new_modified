class AddIndexToPostsByCreated < ActiveRecord::Migration
  def change
  end
  add_index	:posts, :created_at
end
