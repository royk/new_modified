class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :public
      t.boolean :published

      t.timestamps
    end
  end
end
