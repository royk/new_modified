class AddIfpaSanctionedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ifpa_sanctioned, :boolean
  end
end
