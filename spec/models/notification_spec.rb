# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  sender_id   :integer
#  item_id     :integer
#  item_type   :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  action_type :string(255)
#  action_id   :integer
#  public      :boolean
#  read        :boolean          default(FALSE)
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
		it { should respond_to(:action_type) }
		it { should respond_to(:action_id) }
		it { should respond_to(:action) }
		it { should respond_to(:item) }
		it { should respond_to(:user) }
		it { should respond_to(:sender) }
		it { should respond_to(:action_verb) }
		it { should respond_to(:public) }
		it { should respond_to(:read) }

		its(:read) { should==false }
	end


end
