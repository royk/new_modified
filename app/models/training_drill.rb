class TrainingDrill < ActiveRecord::Base
  attr_accessible :contacts_per_attempt, :name, :user_id

	belongs_to :user
  has_many :training_drill_results
  has_many :training_sessions
	def select_name
		"#{name} (#{contacts_per_attempt} contacts)"
	end
end
