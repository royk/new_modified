class AddGravatarSuffixToUsers < ActiveRecord::Migration
	def change
		add_column :users, :gravatar_suffix, :string
	end
end
