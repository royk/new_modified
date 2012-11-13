class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      t.integer :user_id
      t.string :title
      t.string :type

      t.timestamps
    end
  end
end
