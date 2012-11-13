# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  user_id    :integer
#  title      :string(255)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Video < ActiveRecord::Base
  attr_accessible :title, :type, :url

  belongs_to :user

  before_save { |video| video.url = url.downcase }

  validates :user_id, presence: true
  validates :url, presence: true, uniqueness: { case_sensitive: false }

  default_scope order: 'videos.created_at DESC'
end
