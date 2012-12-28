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
	attr_accessible :sender, :read, :public, :item, :action
	
	belongs_to :sender, class_name: "User"
	belongs_to :user

	belongs_to :item, polymorphic: true
	belongs_to :action, polymorphic: true
	alias_attribute :parent_item, :action

	validates :item, presence: true

	def action_verb
		case item.class.to_s
		when "Comment"
			I18n.t(:commented)
		when "Like"
			I18n.t(:liked)
		else
			if action_type=="tag"
				I18n.t(:tagged_you)
			else
				I18n.t(:reacted)
			end
		end
	end
end
