class TrainingDrillResult < ActiveRecord::Base
  attr_accessible :attempts_count, :training_drill_id, :training_session_id, :drops_count
  belongs_to :training_drill
end
