# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  sender_id  :integer
#  item_id    :integer
#  item_type  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Notification do
	before(:all)  { User.delete_all }

	let!(:recepient) { FactoryGirl.create(:user) }

	let!(:notification) { recepient.notifications.build() }

	subject { notification }

	context "Validations" do
		it { should be_valid }
		it { should respond_to(:user_id) }
		it { should respond_to(:sender_id) }
		it { should respond_to(:item_id) }
		it { should respond_to(:item_type) }
		its(:user) { should==recepient }
	end
end
