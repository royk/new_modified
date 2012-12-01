class AddLocationInfoToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :country, :string
  	add_column :users, :city, :string
  	add_index	:users, :country
  end
end
