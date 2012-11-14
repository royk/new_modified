class RemoveUrlFromVideo < ActiveRecord::Migration
  def up
    remove_column :videos, :url
  end

  def down
    add_column :videos, :url, :string
  end
end
