# == Schema Information
#
# Table name: likes
#
#  id              :integer          not null, primary key
#  liker_id        :integer
#  liked_item_id   :integer
#  liked_item_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Like do
	before(:all)  { User.delete_all }

	let!(:liker) { FactoryGirl.create(:user) }
	let!(:item) { FactoryGirl.create(:comment) }

	let!(:notification) { FactoryGirl.create(:notification, sender: sender, item: item) }

	pending "add some examples to (or delete) #{__FILE__}"

end

