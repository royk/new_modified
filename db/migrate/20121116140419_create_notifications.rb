class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :sender_id
      t.integer :item_id
      t.string :item_type

      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
