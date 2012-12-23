class AddPrivacySettingsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :privacy_settings, :integer, default: 0
  end
end
