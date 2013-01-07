# == Schema Information
#
# Table name: results
#
#  id             :integer          not null, primary key
#  competition_id :integer
#  user_id        :integer
#  position       :integer
#  description    :string(255)
#  video_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Result do
  pending "add some examples to (or delete) #{__FILE__}"
end
