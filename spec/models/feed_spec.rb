# == Schema Information
#
# Table name: feeds
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  store_name  :string(255)
#  hidden      :boolean          default(FALSE)
#  user_id     :integer
#  permalink   :string(255)
#  description :text
#

require 'spec_helper'

describe Feed do
  pending "add some examples to (or delete) #{__FILE__}"
end
