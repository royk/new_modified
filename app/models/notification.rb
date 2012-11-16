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
#

class Notification < ActiveRecord::Base
	attr_accessible :sender_id
	
	belongs_to :user

	belongs_to :item, polymorphic: true
	belongs_to :action, polymorphic: true
	def sender
		User.find(sender_id)
	end

	def action_name
		if action.class.to_s=="Comment"
			"commented"
		else
			"reacted"
		end
	end
end
