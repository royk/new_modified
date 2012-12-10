class AddModifiedUserToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :modified_user, :string, unique: true
  end
end
