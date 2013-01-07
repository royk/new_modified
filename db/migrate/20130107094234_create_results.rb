class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :competition_id
      t.integer :user_id
      t.integer :position
      t.string :description
      t.integer :video_id

      t.timestamps
    end
  end
end
