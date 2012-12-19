# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

class Page < ActiveRecord::Base
  attr_accessible :content, :name

  validates :name, presence: true
  validates_length_of :content, :minimum => 0, maximum: 99999, presence: true
end
