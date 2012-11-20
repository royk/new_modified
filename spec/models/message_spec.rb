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

require 'spec_helper'

describe Message do
  pending "add some examples to (or delete) #{__FILE__}"
end
