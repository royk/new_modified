# == Schema Information
#
# Table name: results
#
#  id             :integer          not null, primary key
#  competition_id :integer
#  user_id        :integer
#  position       :integer
#  description    :string(255)
#  video_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Result < ActiveRecord::Base
  attr_accessible :competition_id, :description, :position, :user_id, :video_id

  belongs_to :competition
  belongs_to :user
  belongs_to :video
  
end
