class ChangePublicDefaultOfArticles < ActiveRecord::Migration
  def change
  	change_column :articles, :public, :boolean, default: true
  end
end
