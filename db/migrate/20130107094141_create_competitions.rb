class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.integer :event_id

      t.timestamps
    end
  end
end
