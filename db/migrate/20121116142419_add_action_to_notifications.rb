class AddActionToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :action_type, :string
  	add_column :notifications, :action_id, :integer
  end
end
