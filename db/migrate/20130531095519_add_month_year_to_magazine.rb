class AddMonthYearToMagazine < ActiveRecord::Migration
  def change
	  add_column :magazines, :year, :string
	  add_column :magazines, :month, :string
	  add_index	:magazines, :year
	  add_index	:magazines, :month
  end
end
