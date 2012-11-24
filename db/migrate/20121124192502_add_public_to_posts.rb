class AddPublicToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :public, :boolean, default: true
  end
end
