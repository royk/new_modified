class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :liker_id
      t.integer :liked_item_id
      t.string :liked_item_type

      t.timestamps
    end
    add_index :likes, :liker_id
	add_index :likes, [:liked_item_id, :liked_item_type]
  end
end
