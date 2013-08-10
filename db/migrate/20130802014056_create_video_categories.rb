class CreateVideoCategories < ActiveRecord::Migration
  def change
    create_table :video_categories do |t|
      t.string :name
      t.integer :weight

      t.timestamps
    end
  end
end
