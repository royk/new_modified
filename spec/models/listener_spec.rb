# == Schema Information
#
# Table name: listeners
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  listened_to_id   :integer
#  listened_to_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Listener do
  pending "add some examples to (or delete) #{__FILE__}"
end
