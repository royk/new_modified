# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  city            :string(255)
#  country         :string(255)
#  state           :string(255)
#  start_date      :datetime
#  end_date        :datetime
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ifpa_sanctioned :boolean
#

class Event < ActiveRecord::Base
  attr_accessible :city, :country, :end_date, :name, :start_date, :state, :user_id

  acts_as_trashable

  belongs_to :user
  has_many :attendants
  has_many :competitions
  
  validates :start_date, presence: true
  validates :name, presence: true
  validates :end_date, date: {after_or_equal_to: :start_date, message: "Must be after start date"}

  def location
    [city, country].compact.join(", ")
  end

  def date_formatter(date)
  	date.strftime("%B #{date.mday.ordinalize} %Y") unless date.nil?
  end

end
