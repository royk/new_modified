class AddMetadataToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :location, :string
  	add_column :videos, :maker, :string
  	add_column :videos, :players, :text
  end
end
