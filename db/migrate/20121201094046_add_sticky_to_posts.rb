class AddStickyToPosts < ActiveRecord::Migration
  def change
	add_column :posts, :sticky, :boolean, default: false
  	add_index :posts, :sticky
  end
end
