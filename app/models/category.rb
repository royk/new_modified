# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :name

  acts_as_trashable

  has_many :articles

  validates :name, presence:true, length: {minimum: 1, maximum: 20}, uniqueness:{case_sensitive: true}
end
