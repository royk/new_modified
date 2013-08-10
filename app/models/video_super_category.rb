# == Schema Information
#
# Table name: video_super_categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  permalink  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VideoSuperCategory < ActiveRecord::Base
  attr_accessible :name, :permalink
end
