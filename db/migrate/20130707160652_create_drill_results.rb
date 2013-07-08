class CreateDrillResults < ActiveRecord::Migration
  def change
    create_table :drill_results do |t|
      t.integer :session_id
      t.integer :total_contacts
      t.integer :drops
      t.string :name
      t.boolean :public

      t.timestamps
    end
  end
end
