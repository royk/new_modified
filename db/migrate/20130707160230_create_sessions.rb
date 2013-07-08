class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.datetime :date
      t.integer :user_id

      t.timestamps
    end
  end
end
