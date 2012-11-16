class AddReadToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :read, :boolean
  	add_index :notifications, :read
  end
end
