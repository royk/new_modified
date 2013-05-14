# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conversation < ActiveRecord::Base

	acts_as_trashable

	attr_accessible :messages
	attr_accessor :id

	has_many :messages
	has_many :notifications, as: :item, dependent: :destroy
end
