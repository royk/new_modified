class RenameTypeInVideosToVendor < ActiveRecord::Migration
  def change
  	rename_column :videos, :type, :vendor
  end
end
