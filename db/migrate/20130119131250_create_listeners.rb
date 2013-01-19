class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|
      t.integer :user_id
      t.integer :listened_to_id
      t.string :listened_to_type

      t.timestamps
    end
  end
end
