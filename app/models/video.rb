# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string(255)
#  vendor     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uid        :string(255)
#

class Video < ActiveRecord::Base
  attr_accessible :title, :vendor, :uid

  belongs_to :user

  validates :user_id, presence: true
  validates :uid, presence: true, uniqueness: { case_sensitive: true }
  validates :vendor, presence: true

  default_scope order: 'videos.created_at DESC'
end