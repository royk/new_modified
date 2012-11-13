class AddIndexesToVideosUrl < ActiveRecord::Migration
  def change
  end
  add_index :videos, [:user_id, :created_at]
  add_index :videos, :url, unique: true
end
