class MakeUidOnVideoUnique < ActiveRecord::Migration
	def change
	end
  	add_index :videos, :uid, unique: true
end
