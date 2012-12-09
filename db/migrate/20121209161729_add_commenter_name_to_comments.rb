class AddCommenterNameToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :commenter_name, :string
  end
end
