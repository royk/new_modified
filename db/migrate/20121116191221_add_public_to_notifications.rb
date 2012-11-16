class AddPublicToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :public, :boolean
  end
end
