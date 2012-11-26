class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :user_id
      t.timestamps
  end
      
	 create_table :users do |t|
	 	t.string :name
	 	t.string :email
	 	t.string :remember_token
	 	t.string :password_digest
	 	t.boolean :admin
	 	t.timestamps
	 end
    add_index	:users, :email, unique: true
    add_index	:users, :remember_token
  end
end
