# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  content         :text
#  sender_id       :integer
#  recipient_id    :integer
#  read            :boolean
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ActiveRecord::Base
  attr_accessible :content, :read, :sender, :recipient, :conversation

  acts_as_trashable

  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  belongs_to :conversation

  validates :content, presence: true, length: {minimum: 1}

end
