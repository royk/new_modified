class CreateComments < ActiveRecord::Migration
	def change
		create_table :comments do |t|
		  t.integer :commenter_id
		  t.integer :commentable_id
		  t.string  :commentable_type, :default => "", :null => false
		  t.text :content

		  t.timestamps
		end
		add_index :comments, :commenter_id
		add_index :comments, [:commentable_id, :commentable_type]
	end
end
