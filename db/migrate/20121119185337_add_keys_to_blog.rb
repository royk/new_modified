class AddKeysToBlog < ActiveRecord::Migration
  def change
  	add_index :blogs, [:user_id]
  end
end
