# == Schema Information
#
# Table name: competitions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  index      :integer
#

require 'spec_helper'

describe Competition do
  pending "add some examples to (or delete) #{__FILE__}"
end
