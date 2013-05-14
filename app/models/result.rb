# == Schema Information
#
# Table name: results
#
#  id             :integer          not null, primary key
#  competition_id :integer
#  position       :integer
#  description    :string(255)
#  video_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Result < ActiveRecord::Base
  attr_accessible :competition_id, :description, :position, :users, :video_id, :user, :competition, :video

  acts_as_trashable

  belongs_to :competition
  has_and_belongs_to_many :users, uniq: true
  belongs_to :video
  
end
