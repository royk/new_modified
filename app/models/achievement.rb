# == Schema Information
#
# Table name: achievements
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  user_id          :integer
#  achievement_type :integer
#  date             :datetime
#  public           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  video_id         :integer
#

class Achievement < ActiveRecord::Base
	acts_as_trashable
	attr_accessible :date, :name, :achievement_type, :user_id , :public, :video

	belongs_to :user
	has_many :notifications, as: :item, dependent: :destroy
	has_many :comments, as: :commentable, order: 'created_at ASC'
	has_many :listeners, as: :listened_to, dependent: :destroy
	has_many :likes, as: :liked_item, dependent: :destroy
	belongs_to :video
	accepts_nested_attributes_for :video

	validates :user_id, presence: true
	validates :name, presence: true
	validates :date, presence: true

	def get_type_name_for_feed
		case achievement_type
			when 0
				return "New Trick"
			when 1
				return "New Combo"
			when 2
				return "New Back to Back record"
			when 3
				return "Competition Result"
			when 4
				return "Completed a Challenge"
			when 5
				return "Important Event"
		end
	end
end
