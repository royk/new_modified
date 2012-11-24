class ChangePublicDefaultOnVideos < ActiveRecord::Migration
  def up
  	change_column :videos, :public, :boolean, default: true
  end
end
