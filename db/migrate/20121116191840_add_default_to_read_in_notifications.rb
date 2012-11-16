class AddDefaultToReadInNotifications < ActiveRecord::Migration
  def change
  	change_column :notifications, :read, :boolean, :default => false
  end
end
