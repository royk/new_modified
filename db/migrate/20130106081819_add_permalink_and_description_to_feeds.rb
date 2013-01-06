class AddPermalinkAndDescriptionToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :permalink, :string
    add_column :feeds, :description, :text
  end
end
