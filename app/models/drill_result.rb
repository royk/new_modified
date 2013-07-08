# == Schema Information
#
# Table name: drill_results
#
#  id                  :integer          not null, primary key
#  training_session_id :integer
#  total_contacts      :integer
#  drops               :integer
#  name                :string(255)
#  public              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class DrillResult < ActiveRecord::Base
	attr_accessible :drops, :name, :public, :training_session_id, :total_contacts

	belongs_to :training_session

	validates :training_session_id, presence: true
end
