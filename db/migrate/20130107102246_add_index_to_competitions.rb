class AddIndexToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :index, :integer
  end
end
