# == Schema Information
#
# Table name: competitions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  index      :integer
#

class Competition < ActiveRecord::Base
  attr_accessible :event_id, :name, :event, :index

  belongs_to :event
  has_many :results
end
