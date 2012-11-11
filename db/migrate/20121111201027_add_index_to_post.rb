class AddIndexToPost < ActiveRecord::Migration
  def change
  end
  add_index	:posts, :user_id
end
