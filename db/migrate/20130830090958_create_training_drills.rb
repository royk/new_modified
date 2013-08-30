class CreateTrainingDrills < ActiveRecord::Migration
  def change
    create_table :training_drills do |t|
      t.string :name
      t.integer :contacts_per_attempt
      t.integer :user_id

      t.timestamps
    end
  end
end
