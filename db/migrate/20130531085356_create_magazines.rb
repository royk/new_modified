class CreateMagazines < ActiveRecord::Migration
  def change
    create_table :magazines do |t|
      t.string :name
	  t.string :permalink
      t.datetime :start_date
      t.datetime :end_date
      t.text :video_ids
      t.timestamps
    end
  end
end
