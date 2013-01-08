# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  city            :string(255)
#  country         :string(255)
#  state           :string(255)
#  start_date      :datetime
#  end_date        :datetime
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ifpa_sanctioned :boolean
#

require 'spec_helper'

describe Event do
  pending "add some examples to (or delete) #{__FILE__}"
end
