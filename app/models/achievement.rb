class Achievement < ActiveRecord::Base
	acts_as_trashable
	attr_accessible :date, :name, :achievement_type, :user_id , :public

	belongs_to :user
	has_many :notifications, as: :item, dependent: :destroy
	has_many :comments, as: :commentable, order: 'created_at ASC'
	has_many :listeners, as: :listened_to, dependent: :destroy
	has_many :likes, as: :liked_item

	validates :user_id, presence: true
	validates :name, presence: true
	validates :date, presence: true
	validates :achievement_type, presence: true



end
