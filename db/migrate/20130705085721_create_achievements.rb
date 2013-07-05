class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.string :name
      t.integer :user_id
      t.integer :type
      t.datetime :date
	  t.boolean :public
      t.timestamps
	end
	add_index :achievements, [:user_id]
	add_index :achievements, [:date]
  end
end
