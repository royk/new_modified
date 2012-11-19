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
	attr_accessible :sender_id, :public, :read
	
	belongs_to :user

	belongs_to :item, polymorphic: true
	belongs_to :action, polymorphic: true
	def sender
		User.find(sender_id)
	end

	def action_name
		case action.class.to_s
		when "Comment"
			"commented"
		when "Like"
			"gave kudos"
		else
			"reacted"
		end
	end
end
