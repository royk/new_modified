class AddPermalinkToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :permalink, :string
    add_index :articles, :permalink
  end
  def self.down
    remove_column :articles, :permalink
  end
end