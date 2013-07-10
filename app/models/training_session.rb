# == Schema Information
#
# Table name: training_sessions
#
#  id          :integer          not null, primary key
#  date        :datetime
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public      :boolean
#  description :text
#  video_id    :integer
#

class TrainingSession < ActiveRecord::Base
	attr_accessible :date, :user_id, :public, :description, :drill_results

	belongs_to :user

	has_many :drill_results, dependent: :destroy

	belongs_to :video
	accepts_nested_attributes_for :video

	validates :user_id, presence: true
	validates :date, presence: true

end
