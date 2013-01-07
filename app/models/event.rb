# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city       :string(255)
#  country    :string(255)
#  state      :string(255)
#  start_date :datetime
#  end_date   :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Event < ActiveRecord::Base
  attr_accessible :city, :country, :end_date, :name, :start_date, :state, :user_id

  belongs_to :user
  has_and_belongs_to_many :attendants, class_name: "User", uniq: true
  validates :start_date, presence: true
  validates :name, presence: true
end
