class TrainingDrillResult < ActiveRecord::Base
	attr_accessible :attempts_count, :training_drill_id, :training_session_id, :drops_count, :drops
	belongs_to :training_drill

	def getTotalContacts
		training_drill.contacts_per_attempt * attempts_count
	end

	def drops_as_array
		return drops.squish.split(",").map(&:to_i)
	end

	def get_drop_count
		drops_as_array.length
	end

	def get_summed_drops
		_drops = drops_as_array
		total = 0
		_drops.each do |drop|
			total += drop.to_i
		end
		return total
	end

	def get_drops_average
		get_summed_drops/get_drop_count.to_f
	end

	def get_drops_stdev
		'%.2f' % drops_as_array.standard_deviation
	end

	def get_drop_percentage
		'%.2f' % (get_summed_drops/getTotalContacts.to_f*100.0)
	end
end
