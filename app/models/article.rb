# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  content     :text
#  user_id     :integer
#  public      :boolean          default(TRUE)
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  permalink   :string(255)
#  category_id :integer
#

class Article < ActiveRecord::Base
	has_permalink 

	attr_accessible :created_at, :content, :public, :published, :title, :category, :category_id

	searchable do
		text :content
		text :user do
			user.shown_name unless user.nil?
		end
		time :created_at
	end

	belongs_to :user

	belongs_to :category

	has_many :comments, as: :commentable, order: 'created_at ASC'
	has_many :listeners, as: :listened_to, dependent: :destroy
	has_many :likes, as: :liked_item
  
	has_many :notifications, as: :item, dependent: :destroy

	validates :user_id, presence: true
	validates_length_of :content, :minimum => 1, maximum: 999999, presence: true
	validates :title, allow_blank: false, uniqueness: {case_sensitive: true}
end
