class AddInfoToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :birthday, :datetime
  	add_column :users, :started_playing, :datetime
  	add_column :users, :bap, :boolean, default: false
  	add_column :users, :bap_name, :string
  	add_column :users, :bap_induction, :datetime
  	add_column :users, :motto, :string
  	add_column :users, :hobbies, :text
  end
end
