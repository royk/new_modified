class TrainingDrill < ActiveRecord::Base
  attr_accessible :contacts_per_attempt, :name, :user_id

	belongs_to :user
	def select_name
		"#{name} (#{contacts_per_attempt} contacts)"
	end
end
