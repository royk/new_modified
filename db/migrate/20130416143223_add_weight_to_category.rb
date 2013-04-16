class AddWeightToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :weight, :integer
  end
end
