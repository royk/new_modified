# == Schema Information
#
# Table name: drill_results
#
#  id                  :integer          not null, primary key
#  training_session_id :integer
#  total_contacts      :integer
#  drops               :string(255)
#  name                :string(255)
#  public              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_index         :integer
#

class DrillResult < ActiveRecord::Base
	require 'stdev_extension'

	attr_accessible :drops, :name, :public, :training_session_id, :total_contacts

	belongs_to :training_session

	def get_summed_drops
		_drops = drops_as_array
		total = 0
		_drops.each do |drop|
			total += drop.to_i
		end
		return total
	end

	def get_drop_count
		drops_as_array.length
	end

	def get_drops_average
		get_summed_drops/get_drop_count.to_f
	end

	def get_drops_stdev
		'%.2f' % drops_as_array.standard_deviation
	end

	def get_drop_percentage
		'%.2f' % (get_summed_drops/total_contacts.to_f*100.0)
	end

	def drops_as_array
		return drops.squish.split(",").map(&:to_i)
	end
end
