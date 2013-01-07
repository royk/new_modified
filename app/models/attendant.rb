# == Schema Information
#
# Table name: attendants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role       :string(255)
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Attendant < ActiveRecord::Base
  attr_accessible :event_id, :role, :user_id, :user, :event

  belongs_to :user
  belongs_to :event

end
