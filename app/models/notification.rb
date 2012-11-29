# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  sender_id   :integer
#  item_id     :integer
#  item_type   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  action_type :string(255)
#  action_id   :integer
#  public      :boolean
#  read        :boolean          default(FALSE)
#

class Notification < ActiveRecord::Base
	attr_accessible :sender, :read, :public
	
	belongs_to :sender, class_name: "User"
	belongs_to :user

	belongs_to :item, polymorphic: true
	belongs_to :action, polymorphic: true

	validates :sender, presence: true
	validates :item, presence: true

	def action_verb
		case action.class.to_s
		when "Comment"
			"commented"
		when "Like"
			"gave kudos"
		else
			if action_type=="tag"
				"tagged you"
			else
				"reacted"
			end
		end
	end

	def join_message
		"joined the community"
	end
end
