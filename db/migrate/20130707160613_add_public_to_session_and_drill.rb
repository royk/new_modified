class AddPublicToSessionAndDrill < ActiveRecord::Migration
  def change
	  add_column :sessions, :public, :boolean
  end
end
