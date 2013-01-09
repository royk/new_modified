class CreateResultsUsersTable < ActiveRecord::Migration
  def change
  	create_table :results_users, :id=>false do |t|
      t.integer :user_id
      t.integer :result_id
    end
  end
end
